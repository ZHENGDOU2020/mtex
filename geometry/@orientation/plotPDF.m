function plotPDF(o,varargin)
% plot orientations into pole figures
%
% Syntax
%   plotPDF(ori,[h1,h2,h3])
%   plotPDF(ori,[h1,h2,h3],'points',100)
%   plotPDF(ori,[h1,h2,h3],'points','all')
%   plotPDF(ori,[h1,h2,h3],'contourf')
%   plotPDF(ori,[h1,h2,h3],'antipodal')
%   plotPDF(ori,[h1,h2,h3],'superposition',{1,[1.5 0.5]})
%   plotPDF(ori,data,[h1,h2,h3])
%
% Input
%  ori - @orientation
%  h   - @Miller crystallographic directions
%
% Options
%  superposition - plot superposed pole figures
%  points        - number of points to be plotted
%
% Flags
%  antipodal - include <AxialDirectional.html antipodal symmetry>
%  complete  - plot entire (hemi)--sphere
%
% See also
% orientation/plotIPDF S2Grid/plot savefigure
% Plotting Annotations_demo ColorCoding_demo PlotTypes_demo
% SphericalProjection_demo

% extract data
if check_option(varargin,'property')
  data = get_option(varargin,'property');
  data = reshape(data,[1,length(o) numel(data)/length(o)]);
elseif nargin > 2 && isa(varargin{2},'Miller')
  [data,varargin] = extract_data(length(o),varargin);
  data = reshape(data,[1,length(o) numel(data)/length(o)]);
else
  data = [];
end

%  subsample orientations if there are to many
if ~check_option(varargin,{'all','contour','contourf','smooth'}) && ...
    (sum(length(o))*length(o.CS)*length(o.SS) > 10000 || check_option(varargin,'points'))

  points = fix(get_option(varargin,'points',10000/length(o.CS)/length(o.SS)));
  disp(['  I''m plotting ', int2str(points) ,' random orientations out of ', int2str(length(o)),' given orientations']);
  disp('  You can specify the the number points by the option "points".'); 
  disp('  The option "all" ensures that all data are plotted');
  
  samples = discretesample(length(o),points);
  o= o.subSet(samples);
  if ~isempty(data), data = data(:,samples,:); end
    
end

% generate empty pole figure plots
[pfP,mtexFig,isNew] = pfPlot.new(o.SS,varargin{:},'datacursormode',@tooltip);

% plot
for i = 1:length(pfP)

  % compute specimen directions
  sh = symmetrise(pfP(i).h);
  r = reshape(o.SS * o * sh,[],1);
  
  r.plot(repmat(data,[length(o.SS) length(sh)]),'fundamentalRegion',...
    'parent',pfP(i).ax,'doNotDraw',varargin{:});  
end

if isNew || check_option(varargin,'figSize')
  set(gcf,'Name',['Pole figures of "',inputname(1),'"']);
  pause(1)
  drawNow(gcm,'figSize',getMTEXpref('figSize'),varargin{:}); 
end

if check_option(varargin,'3d')  
  datacursormode off
  fcw(gcf,'-link'); 
end

% tooltip function
function txt = tooltip(varargin)

[r_local,id] = getDataCursorPos(mtexFig);

txt = ['id ' xnum2str(id) ' at (' int2str(r_local.theta/degree) ',' int2str(r_local.rho/degree) ')'];

end

end
