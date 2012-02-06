function [cmp v]= hullprincipalcomponents(p)
% returns the principalcomponents of convexhull
%
%% Input
%  p - @grain / @polygon
%
%% Output
%  cmp   - angle of components as complex
%  v     - length of axis
%
%% See also
% polygon/principalcomponents grain/plotEllipse
%

[cmp v] = principalcomponents(convhull(p));