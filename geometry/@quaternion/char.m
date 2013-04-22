function s = char(q,varargin)
% quaternion to char

if length(q) == 1
  if check_option(varargin,'EULER')
    [alpha,beta,gamma] = Euler(q);
    s = ['(',int2str(alpha/degree),mtexdegchar,',',int2str(beta/degree),mtexdegchar,',',int2str(gamma/degree),mtexdegchar,')'];
  else
    % v = vector3d(q.b,q.c,q.d);
    % s = ['rot axis: ',char(v./norm(v)),', rot angle: ',int2str(2*acos(q.a)/degree),mtexdegchar];
    s = xnum2str([q.a,q.b,q.c,q.d]);
  end
else
  s = ['Quaternions: ',num2str(size(q,1)),'x',num2str(size(q,2))];
end
