function status = odespatial(t,y,flag,N,nspecies,X,colors,varargin)
%ODEPHAS2  2-D phase plane ODE output function.
%   When the function odephas2 is passed to an ODE solver as the 'OutputFcn'
%   property, i.e. options = odeset('OutputFcn',@odephas2), the solver
%   calls ODEPHAS2(T,Y,'') after every timestep.  The ODEPHAS2 function plots
%   the first two components of the solution it is passed as it is computed,
%   adapting the axis limits of the plot dynamically.  To plot two
%   particular components, specify their indices in the 'OutputSel' property
%   passed to the ODE solver.
%   
%   At the start of integration, a solver calls ODEPHAS2(TSPAN,Y0,'init') to
%   initialize the output function.  After each integration step to new time
%   point T with solution vector Y the solver calls STATUS = ODEPHAS2(T,Y,'').
%   If the solver's 'Refine' property is greater than one (see ODESET), then
%   T is a column vector containing all new output times and Y is an array
%   comprised of corresponding column vectors.  The STATUS return value is 1
%   if the STOP button has been pressed and 0 otherwise.  When the
%   integration is complete, the solver calls ODEPHAS2([],[],'done').
%
%   See also ODEPLOT, ODEPHAS3, ODEPRINT, ODE45, ODE15S, ODESET.

%   Mark W. Reichelt and Lawrence F. Shampine, 3-24-94
%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.26.4.9 $  $Date: 2011/07/25 03:45:09 $

persistent TARGET_FIGURE TARGET_AXIS TARGET_HGCLASS

status = 0;                             % Assume stop button wasn't pushed.
chunk = 128;                            % Memory is allocated in chunks.

drawnowDelay = 2;  % HGUsingMATLABClasses - postpone drawnow for performance reasons
doDrawnow = true;  % default

if X(1) == 0
  Xout = zeros(1,N+1);
  Xout(1:N) = X;
  Xout(N+1) = Xout(1);
else
  Xout = zeros(1,N+2);
  Xout(1) = 0;
  Xout(N+2) = 1;
  Xout(2:N+1) = X;
end

if nargin < 3 || isempty(flag) % odephas2(t,y) [v5 syntax] or odephas2(t,y,'')

    
    if (isempty(TARGET_FIGURE) || isempty(TARGET_AXIS))
        
        error(message('MATLAB:odephas2:NotCalledWithInit'));
        
    elseif (ishghandle(TARGET_FIGURE) && ishghandle(TARGET_AXIS))  % figure still open   

        try 
            
            ud = get(TARGET_FIGURE,'UserData');
            
            if TARGET_HGCLASS
                doDrawnow = (ud.drawnowSteps > drawnowDelay);
                if doDrawnow
                    ud.drawnowSteps = 1;
                else
                    ud.drawnowSteps = ud.drawnowSteps + 1;
                end
            end                
            
            set(TARGET_FIGURE,'UserData',ud);
     
            if ud.stop == 1                       % Has stop button been pushed?
                status = 1;
            else
                % Rather than redraw all of the data every timestep, we will simply move
                % the line segments for the new data, not erasing.  But if the data has
                % moved out of the axis range, we redraw everything.
%                 xlim = get(TARGET_AXIS,'xlim');
%                 ylim = get(TARGET_AXIS,'ylim');
                          
                % Replot everything if out of axis range or if just initialized.
%                 if (oldi == 1) || ...
%                           (min(y(1,:)) < xlim(1)) || (xlim(2) < max(y(1,:))) || ...
%                           (min(y(2,:)) < ylim(1)) || (ylim(2) < max(y(2,:)))
                for species = 1:nspecies
                    if X(1) == 0
                      ynew = zeros(nspecies,N+1);        
                      ynew(species,1:N) = y((species-1)*N+1:species*N);
                      ynew(species,N+1) = ynew(species,1);
                    else
                      ynew = zeros(nspecies,N+2);
                      ynew(species,1) = (y((species-1)*N+1)+y(species*N))/2;
                      ynew(species,2:N+1) = y((species-1)*N+1:species*N);
                      ynew(species,N+2) = ynew(species,1);
                    end
                    set(ud.lines(species), ...
                        'Xdata',Xout, ...
                        'Ydata',ynew);
                      
                    maxspecies = ud.max(species);
                    maxYdata = get(maxspecies,'Ydata');
                    for spacept = 1:N
                      if y((species-1)*N+spacept) > maxYdata(spacept)                    
                        set(maxspecies, ...
                            'Xdata',Xout, ...
                            'Ydata',ynew);
                        break;
                      end
                    end
                    
                    minspecies = ud.min(species);
                    minYdata = get(minspecies,'Ydata');
                    for spacept = 1:N
                      if y((species-1)*N+spacept) < minYdata(spacept)                    
                        set(minspecies, ...
                            'Xdata',Xout, ...
                            'Ydata',ynew);
                        break;
                      end
                    end
                end
                
%                     set(ud.line, ...
%                         'Xdata',ud.y(oldi:newi,1), ...
%                         'Ydata',ud.y(oldi:newi,2));
%                 else
%                     % Plot only the new data.
%                     if doDrawnow                         
%                         if TARGET_HGCLASS  % start new segment           
%                             if ~ishold
%                                 hold on 
%                                 plot(ud.y(ploti:newi,1),ud.y(ploti:newi,2),'-o');        
%                                 hold off
%                             else
%                                 plot(ud.y(ploti:newi,1),ud.y(ploti:newi,2),'-o');        
%                             end
%                         else
%                             co = get(TARGET_AXIS,'ColorOrder');             
%                             set(ud.line,'Color',co(1,:));     % "erase" old segment
%                             set(ud.line, ...
%                                 'Xdata',ud.y(oldi:newi,1), ...
%                                 'Ydata',ud.y(oldi:newi,2), ...
%                                 'Color',co(2,:));
%                         end
%                     end
%                 end
            end
            
        catch ME
            error(message('MATLAB:odephas2:ErrorUpdatingWindow', ME.message));
        end                                          
    end
  
else
    
    switch(flag)
      case 'init'                           % odespatial(tspan,y0,'init')
        TARGET_HGCLASS = feature('HGUsingMATLABClasses');
        
%         ud.y = zeros(chunk,2);
%         ud.i = 1;
        
        ud.y = zeros(1,N*nspecies);
        ud.y(:) = y.';

        % Rather than redraw all data at every timestep, we will simply move
        % the last line segment along, not erasing it.
        f = figure(gcf);
        
        TARGET_FIGURE = f;
        TARGET_AXIS = gca;
        
        if TARGET_HGCLASS
            EraseMode = {};
%             ud.ploti = 1;                            
            ud.drawnowSteps = 1;                            
        else            
            EraseMode = {'EraseMode','none'};
        end
        
        if X(1) == 0
          ynew = zeros(nspecies,N+1);
          for species = 1:nspecies          
            ynew(species,1:N) = y((species-1)*N+1:species*N);
            ynew(species,N+1) = ynew(species,1);
          end
        else
          ynew = zeros(nspecies,N+2);
          for species = 1:nspecies 
            ynew(species,1) = (y((species-1)*N+1)+y(species*N))/2;
            ynew(species,2:N+1) = y((species-1)*N+1:species*N);
            ynew(species,N+2) = ynew(species,1);
          end
        end
          
        if ~ishold
          ud.lines(1) = plot(X,ynew(1,:),strcat(colors(1),'-o'));
          hold on
          ud.minlines(1) = plot(X,ynew(1,:),strcat(colors(1),'--o'));
          ud.maxlines(1) = plot(X,ynew(1,:),strcat(colors(1),'--o'));
          for species = 2:nspecies              
            ud.lines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'-o'));
            ud.minlines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'--o'));
            ud.maxlines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'--o'));
          end          
          hold off
%             hold on
%             ud.line = plot(y(1),y(2),'-o','Color',co(2,:),EraseMode{:});
%             hold off
        else
          ud.lines(1) = plot(X,ynew(1,:),strcat(colors(1),'-o'),EraseMode{:});
          hold on
          ud.minlines(1) = plot(X,ynew(1,:),strcat(colors(1),'--o'),EraseMode{:});
          ud.maxlines(1) = plot(X,ynew(1,:),strcat(colors(1),'--o'),EraseMode{:});
          for species = 2:nspecies
            ud.lines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'-o'),EraseMode{:});
            ud.minlines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'--o'),EraseMode{:});
            ud.maxlines(species) = plot(Xout,ynew(species,:),strcat(colors(species),'--o'),EraseMode{:});
          end
          hold off
%             ud.line = plot(y(1),y(2),'-o','Color',co(2,:),EraseMode{:});
        end
        
        % The STOP button.
        h = findobj(f,'Tag','stop');
        if isempty(h)
            ud.stop = 0;
            pos = get(0,'DefaultUicontrolPosition');
            pos(1) = pos(1) - 15;
            pos(2) = pos(2) - 15;            
            uicontrol( ...
                'Style','push', ...
                'String',getString(message('MATLAB:odephas2:ButtonStop')), ...
                'Position',pos, ...
                'Callback',@StopButtonCallback, ...
                'Tag','stop');
        else
            set(h,'Visible','on');            % make sure it's visible
            if ishold
                oud = get(f,'UserData');
                ud.stop = oud.stop;             % don't change old ud.stop status
            else
                ud.stop = 0;
            end
        end
        set(f,'UserData',ud);
    
      case 'done'                           % odephas2([],[],'done')

        f = TARGET_FIGURE;
        TARGET_FIGURE = []; 
        ta = TARGET_AXIS;
        TARGET_AXIS = [];
        
        if ishghandle(f)
%             ud = get(f,'UserData');
%             ud.y = ud.y(1:ud.i,:);
%             set(f,'UserData',ud);
            if ~ishold
                set(findobj(f,'Tag','stop'),'Visible','off');
                
                if ishghandle(ta)
                    set(ta,'XLimMode','auto');
                end
                
                refresh;                          % redraw figure to remove marker frags
            end
        end
    
    end
end

if doDrawnow
    drawnow;
end

end  % odephas2


% --------------------------------------------------------------------------
% Sub-function
%

function StopButtonCallback(src,eventdata)
    ud = get(gcbf,'UserData'); 
    ud.stop = 1; 
    set(gcbf,'UserData',ud);    
end  % StopButtonCallback

% --------------------------------------------------------------------------
