function T = subsasgn(T,s,b)
% overloads subsasgn

if T.rank == 4
  M = tensor42(T.M,T.doubleConvention);
  M = subsasgn(M,s,b);
  T.M = tensor24(M,T.doubleConvention);
elseif T.rank == 3
  M = tensor32(T.M,T.doubleConvention);
  M = subsasgn(M,s,b);
  T.M = tensor23(M,T.doubleConvention);
else
  T.M = subsasgn(T.M,s,b);
end
