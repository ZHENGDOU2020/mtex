function cg = sphericalClebschGordan(l,L)

% correction matrix
A = zeros(2*l+1,2*l+1);
[x,y] = find(~A);
A(x+y>=2*l+2 & x <=l+1 & rem(x-l-1,2)) =1;
A = or(A,A');
A = or(A,fliplr(fliplr(A)'));
A = 1 - 2*A;

cg = zeros(2*l+1,2*l+1);
for m1 = -l:l
  for m2 = -l:l
    cg(l+1+m1,l+1+m2)...
      = ClebschGordan(l,l,L,0,0,0) * ...
      ClebschGordan(l,l,L,m1,m2,m1+m2) * A(l+1+m1,l+1+m2);
  end
end

cg = flipud(cg);

return

%% testin code:

% compute products of spherical harmonics
% for a certain position 
theta = 15*degree;
rho = 10*degree;
l = 1;

Y = sphericalY(l,theta,rho);

YYref = Y' * Y;
%YYref = Y.' * Y;

%% 


YY = zeros(size(YYref));

for L = 0:2*l
  
  cg = (2*l+1) ./ sqrt(4*pi*(2*L+1)) * sphericalClebschGordan(l,L);
  Y = repmat(sphericalY(L,theta,rho),2*l+1,1);
  
  DY = full(spdiags(Y,-L:L,2*l+1,2*l+1));
  
  YY = YY + cg .* DY;
  
end

assert(max(max(abs(1-YYref ./ YY)))<1e-10)
disp('Everythink is ok!')

%%

