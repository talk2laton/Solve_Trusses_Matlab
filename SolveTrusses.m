function SolveTrusses(Nodes, Edges, Loads, Supports, Hull, Name)
Lmax = 0;
Connections = {}; Members = {};
if nargin < 6
    Name = '';
end
cross = @(u,v) u(1)*v(2) - u(2)*v(1);
Alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
MemberLabels = [];
%% Identifying Nodes and Connecting Members
for n = 1:size(Edges, 1)
    M = Nodes(Edges(n,:),:); Members = [Members, M]; 
    dxdy = diff(M); Lmax = max(Lmax, norm(dxdy)); 
end
for n = 1:size(Nodes,1)
    Connection = [];
    for m = 1:numel(Members)
        if (sum(ismember(Nodes(n,:), Members{m}, 'rows')) > 0)
            Connection = [Connection, m];
        end
    end
    Connections = [Connections,Connection];
end
xH = Nodes(Hull,1); yH = Nodes(Hull,2);
NodeLoads = {};
for m = 1:size(Nodes,1)
    NodeLoads = [NodeLoads,{[]}];
end 
for m = 1:numel(Members)
    Member = Members{m};
    i = find(ismember(Nodes, Member, 'rows'));
    MemberLabels = [MemberLabels;Alphabets(mod(i-1,26)+1)];
end
[~,r] = sort(MemberLabels);
t = Lmax/30;

%% Adding Support
figure('Name', [Name,'-Truss and forces in members'], 'Position', [533 100 918 500], 'Color', 'w');
s = 0.8;
ax1 = axes('Position',[0.0,0.0, s, 1.0],'Visible','off');
ax2 = axes('Position',[s,  0.0,1-s,1.0],'Visible','off');
axes(ax1)
Pins = []; PinC = [];
for n = 1:numel(Supports)
    Support = Supports{n};
    if Support(1) == 1
        [Xt,Yt, Xr, Yr] = makesupport1(Support(2:3), t, Support(4));
        fill(Xt,Yt,[0.5,0.5,0.5]); hold on;
        fill(Xr,Yr,[0.7,0.7,0.7]);
        Pin = n; Pins = [Pins,n];
    else
        [Xt,Yt, Xr, Yr, Xl, Yl, Xc, Yc] = makesupport2(Support(2:3), t, Support(4));
        fill(Xt,Yt,[0.5,0.5,0.5]); hold on;
        fill(Xr,Yr,[0.7,0.7,0.7]);
        plot(Xl,Yl,'k', 'linewidth',2); 
        for m = 1:size(Xc,1)
            fill(Xc(m,:),Yc(m,:),[0.7,0.7,0.7]);
        end
        Roller = n;
    end
    for m = 1:size(Nodes,1)
        if Support(2:3) == Nodes(m,:)
            if(numel(Connections{m})>1)
                PinC = [PinC, 0];
            else
                PinC = [PinC, Connections{m}];
            end
            NodeLoads{m} = [NodeLoads{m},numel(Loads) + n];
            break;
        end  
    end
end
if (numel(Pins) > 1)
    [PinC, ii]= sort(PinC);
    Pins = Pins(ii);
end
%% Drawing Members
for n = 1:numel(Members)
    Member = Members{n};
    [X1,Y1, X2, Y2] =  makemember(Member, t);
    fill(X1,Y1,[0.5,0.5,0.5]); 
    fill(X2,Y2,[0.7,0.7,0.7]);
end
daspect([1,1,1]);

%% Drawing Nodes
x = t/2*cos(linspace(0,2*pi,100));
y = t/2*sin(linspace(0,2*pi,100));
for n  = 1:size(Nodes,1)
    fill(x + Nodes(n,1),y + Nodes(n,2),[1,0,0]);
end
box off
axis off;
%% Resolve Loads
RLoads = {};
xl = xlim; yl = ylim; Arrowlength = norm([xl,yl])/10;
for n = 1:numel(Loads)
    Load   = Loads{n}; c = cos(Load(4)); s = sin(Load(4));
    Px     = Load(3)*c*(abs(c)>=1e-10);
    Py     = Load(3)*s*(abs(s)>=1e-10);
    Rload  = [Load(1:2),Px,Py];
    RLoads = [RLoads,Rload];
    for m = 1:size(Nodes,1)
        if Load(1:2) == Nodes(m,:)
            NodeLoads{m} = [NodeLoads{m}, n];
            break;
        end  
    end
    dx = c*Arrowlength; dy = s*Arrowlength;
    x1 = Load(1); y1 = Load(2); x2 = x1 + dx; y2 = y1 + dy;
    x3 = x1 + 1.2*dx; y3 = y1 + 1.2*dy;
    if(inpolygon(Load(1)+dx,Load(2)+dy, xH, yH))
        dx = -dx; dy = -dy; x2 = x1 + dx; y2 = y1 + dy;
        x3 = x1 + 1.2*dx; y3 = y1 + 1.2*dy;
        [Xar, Yar] = Arrow([x2,y2],[x1,y1]);
    else
        [Xar, Yar] = Arrow([x1,y1],[x2,y2]);
    end
    fill(Xar,Yar,[0.7,0.2,0.2]); 
    text(x3, y3, [num2str(abs(Load(3)),'%.0f'),'N'],...
    'FontSize',12 ,'FontWeight','bold', 'HorizontalAlignment','center', 'interpreter','latex');
end
%% Solving
S = zeros(2);
% Take Moment about Pin

M = 0; PinSupport = Supports{Pins(1)};
for n =  1:numel(RLoads)
    RLoad    = RLoads{n};
    dr       = RLoad(1:2) - PinSupport(2:3);
    M        = M + cross(dr, RLoad(3:4));
    S(Pins(1),:) = S(Pins(1),:) - RLoad(3:4);
end
if(numel(Pins) == 1)
    RollerSupport  = Supports{Roller};
    dr             = RollerSupport(2:3) - PinSupport(2:3);
    angle          = (1 + RollerSupport(4))*pi/2; c = cos(angle); s = sin(angle);
    RollerNormal   = M/cross([c*(abs(c)>1e-10), s*(abs(s)>1e-10)],dr);
    S(Roller,:)    = RollerNormal*[c*(abs(c)>1e-10), s*(abs(s)>1e-10)];
    S(Pin,:)       = S(Pin,:) - S(Roller,:);
else
    PinSupport2    = Supports{Pins(2)};
    dr             = PinSupport2(2:3) - PinSupport(2:3);
    Member         = Members{PinC(2)}; dc = diff(Member)/norm(diff(Member));
    Pin2onMember   = M/cross(dc,dr);
    S(Pins(2),:)   = Pin2onMember*dc;
    S(Pins(1),:)   = S(Pins(1),:) - S(Pins(2),:);
end

%% Add Support Reactions to RLoads
for n = 1:size(S,1)
    RLoads = [RLoads,[Supports{n}(2:3),S(n,:)]];
end

%% Calculate Members Forces
A = zeros(2*size(Nodes, 1), numel(Members));
b = zeros(2*size(Nodes, 1), 1);
for n = 1:size(Nodes, 1)
    Node = Nodes(n,:); Angles = [];
    for m = Connections{n}
        Member = Members{m};
        j = 1; i = 2;
        if Node == Member(1,:)
            i = 1; j = 2; 
        end
        D = Member(i,:) - Member(j,:);
        L = norm(D);
        C = D/L; % Direction Cosines Assuming Compression as default
        A(2*n-1, m) = C(1);  A(2*n-0, m) = C(2);
        angle = atan2(-C(2), -C(1));
        if(angle < 0)
            angle = angle + 2*pi;
        end
        Angles = [Angles, angle];
    end
    Angles = sort(Angles); Angles = [Angles, Angles(1) + 2*pi];
    d_angle = diff(Angles); m_angle = (Angles(1:end-1) + 2*Angles(2:end))/3;
    [~,i] = max(d_angle); angle   = m_angle(i);
    text(Node(1) + 3*t*cos(angle),Node(2) + 3*t*sin(angle),....
        Alphabets(n), 'FontSize',15 ,'FontWeight','bold',...
        'HorizontalAlignment','center', 'interpreter','latex');
    for m = NodeLoads{n}
        b(2*n-1) = b(2*n-1) - RLoads{m}(3); 
        b(2*n-0) = b(2*n-0) - RLoads{m}(4); 
    end
end

MLoads = A\b;
Check  = A*MLoads - b;

Correct = all(abs(Check)<1e-10);
% print results on members
SolString = {};
for n = 1:numel(MLoads)
    coord = mean(Members{n});
    del   = diff(Members{n});
    angle = (180/pi)*atan(del(2)/ del(1));
    if(MLoads(n)>0)
        Text = [num2str(abs(MLoads(n)),'%.2f'),'N (C)'];
    else
        Text = [num2str(abs(MLoads(n)),'%.2f'),'N (T)'];
    end
    h = text(coord(1),coord(2),Text, 'FontSize',10 ,'FontWeight','bold',...
        'HorizontalAlignment','center', 'interpreter','latex');
    SolString = [SolString,['$F_{',MemberLabels(n,:),'} = ',Text,'$']];
    set(h,'Rotation',angle);
end
if (Correct)
    title('Solution displayed on each member')
else
    title({'error check suggests the problem not solved correctly,',... 
          'please use Solution displayed on each member with caution'});
end
axes(ax2)
SolString = SolString(r(:,1));
text(0.05, 0.95, SolString, 'VerticalAlignment', 'cap', 'FontSize', 12, 'interpreter', 'latex')


function [X1,Y1, X2, Y2]  =  makemember(M, t)
dxdy  = diff(M); L = norm(dxdy);
angle = atan2(dxdy(2),dxdy(1));
t1    = linspace(pi/2,-pi/2,50);
t2    = linspace(3*pi/2,pi/2,50);
XYp1  = [0, L, L + t*cos(t1), L, 0, t*cos(t2);
         t, t, 0 + t*sin(t1), -t, -t, t*sin(t2)];
XYp2  = [0, L, L + 0.67*t*cos(t1), L, 0, 0.67*t*cos(t2);
         0.67*t, 0.67*t, 0 + 0.67*t*sin(t1), -0.67*t, -0.67*t, 0.67*t*sin(t2)];
XY1    = [cos(angle), -sin(angle); sin(angle), cos(angle)]*XYp1;
XY2    = [cos(angle), -sin(angle); sin(angle), cos(angle)]*XYp2;
X1     = M(1,1) + XY1(1,:);    Y1     = M(1,2) + XY1(2,:);
X2     = M(1,1) + XY2(1,:);    Y2     = M(1,2) + XY2(2,:);

function [Xt,Yt, Xr, Yr] = makesupport1(Node, t, n)
t    = 0.7*t; y = 4*t; x = t*cos(pi/6)*5.5/1.5;
t1   = linspace(5*pi/6, pi/6, 50); angle = n*pi/2;
M    = [cos(angle), -sin(angle); sin(angle), cos(angle)];
XYpt = [t*cos(t1), x, -x; t*sin(t1),-y,-y];
XYpr = [1.2*x, 1.2*x, -1.2*x, -1.2*x; -y, -1.2*y, -1.2*y, -y];
XYt  = M*XYpt; XYr  = M*XYpr;
Xt   = Node(1) + XYt(1,:);    Yt     = Node(2) + XYt(2,:);
Xr   = Node(1) + XYr(1,:);    Yr     = Node(2) + XYr(2,:);

function [Xt,Yt, Xr, Yr, Xl, Yl, Xc, Yc] = makesupport2(Node, t, n)
t    = 0.7*t; y = 3*t; x = t*cos(pi/6)*4.5/1.5;
t1   = linspace(5*pi/6, pi/6, 50); angle = n*pi/2;
M    = [cos(angle), -sin(angle); sin(angle), cos(angle)];
XYpt = [t*cos(t1), x, -x; t*sin(t1),-y,-y];
y2   = 4*t; x2 = t*cos(pi/6)*5.5/1.5;
XYpl = [x2, -x2; -y, -y];
XYpr = [1.2*x2, 1.2*x2, -1.2*x2, -1.2*x2; -y2, -1.2*y2, -1.2*y2, -y2];
XYt  = M*XYpt; XYr  = M*XYpr; XYl  = M*XYpl;
Xt   = Node(1) + XYt(1,:);    Yt     = Node(2) + XYt(2,:);
Xr   = Node(1) + XYr(1,:);    Yr     = Node(2) + XYr(2,:);
Xl   = Node(1) + XYl(1,:);    Yl     = Node(2) + XYl(2,:);
Xc   = []; Yc = [];
for n = 1:6
    xc = (-3.5 + n)*t + 0.5*t*cos(linspace(0,2*pi,100));
    yc = -3.5*t + 0.5*t*sin(linspace(0,2*pi,100));
    XYpc = [xc;yc]; XYc  = M*XYpc;
    Xc   = [Xc; Node(1) + XYc(1,:)] ;
    Yc   = [Yc; Node(2) + XYc(2,:)] ;
end

function [X,Y] = Arrow(start, stop)
del   = stop-start;
L     = norm(del);
t     = L/40;
angle = atan2(del(2), del(1));
XYp   = t*[0, 32, 32, 40, 32, 32, 0, 0; 1, 1, 3, 0, -3, -1, -1, 1];
XY    = [cos(angle), -sin(angle); sin(angle), cos(angle)]*XYp;
X     = start(1) + XY(1,:); Y   = start(2) + XY(2,:);
