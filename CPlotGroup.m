classdef CPlotGroup < handle
    %CPLOTGROUP Group of plots on uipanel
    
    properties
        
        pan_handle
        but_handle
        PG_CounterVal
        Active
        Width
        Height
        FontSize = 8;
        Canvas = 50;
        BPG_Length = 100; % Button of PG length           
        
        AxesArr = zeros(6, 6); % Posible place of axes        
        AxesCounter 
        A % Axes Handles List
        AxesFunction
        
        
    end
    
    methods
        
        function PG = CPlotGroup(parent, CounterValue, Name, Position, BPGP)
            PG.pan_handle = uipanel(parent, 'Title', Name, ... % Frame on MW
                            'BackgroundColor', get(parent, 'Color'));
            set(PG.pan_handle, 'Units', 'pixels');
            PG.PG_CounterVal = CounterValue; % PG number on MW
            PG.AxesCounter = 0;
            PG.setPosition(Position);
            
            PG.but_handle = uicontrol(BPGP.handle, 'Style', 'pushbutton', 'Units', 'pixels');
            set(PG.but_handle, 'Position', [round(BPGP.Height*0.125) + round((CounterValue-1)*PG.BPG_Length*1.1), ...
                round(BPGP.Height*0.125), PG.BPG_Length, round(BPGP.Height*0.75)], ...
                'String', 'PG1');
            set(PG.but_handle, 'Callback', ['MW.PG{' num2str(CounterValue) '}.BtnDwn(MW)']);
        end
        
        function ActiveOff(PG)
            PG.Active = 0;
            set(PG.pan_handle, 'Visible', 'Off');
        end
        
        function ActiveOn(PG)
            PG.Active = 1;
            set(PG.pan_handle, 'Visible', 'On');
        end        
        
        function erro = newAxes(PG, ArrVal, Func)
            
            erro = 1;
            if sum((ArrVal + PG.AxesArr) > 1) 
                return
            end
            
            %Find place for axes
            x0 = 0; y0 = 0;
            maxy = size(PG.AxesArr,1);
            maxx = size(PG.AxesArr,2);
            for i = 1:maxy
                for j = 1:maxx
                    if ArrVal(i, j) == 1
                        if (x0 == 0)&&(y0 == 0)
                            x0 = j;
                            y0 = i;
                            erro = 0;
                        end
                    end
                end
            end
            
            xend = x0;
            yend = y0;
            for i = y0:maxy
                for j = x0:maxx
                    if ~sum(ArrVal(y0:i, x0:j) == 0)
                        if ((j-x0 +1)*(i-y0 +1) > (xend-x0 +1)*(yend-y0 +1)) 
                            xend = j;
                            yend = i;
                        end
                    end
                end
            end
            
            y0 = maxy - y0 + 1; % From top left
            
            pos(1) = (PG.Width/maxx) * (x0-1) + PG.Canvas; 
            pos(2) = (PG.Height/maxy) * (y0-1) + PG.Canvas; 
            pos(3) = (PG.Width/maxx) * (xend - x0 + 1) - 2*PG.Canvas;
            pos(4) = (PG.Height/maxy) * (yend - y0 + 1) - 2*PG.Canvas;
            
            if (pos(3) > 1)&&(pos(4) > 1) % All OK?
                erro = 0;
                PG.AxesArr(y0:yend, x0:xend) = 1;
                PG.AxesCounter = PG.AxesCounter + 1;
                PG.A(PG.AxesCounter) = axes('Parent', PG.pan_handle);
                set(PG.A(PG.AxesCounter), 'Units', 'pixels');
                set(PG.A(PG.AxesCounter), 'FontSize', PG.FontSize);                
                set(PG.A(PG.AxesCounter), 'Position', pos);
                PG.AxesFunction{PG.AxesCounter} = [Func  '(PG.A(' num2str(PG.AxesCounter) ', 0)' ];
                Func = [Func sprintf('(%02.0f%02.0f, 1)', PG.PG_CounterVal, PG.AxesCounter)];
                set(PG.A(PG.AxesCounter), 'ButtonDownFcn', Func);
            end
        end
        
        function setPosition(PG, pos)
            PG.Width = pos(3);
            PG.Height = pos(4);   
            set(PG.pan_handle, 'Position',  pos);     
        end
            
        function BtnDwn(PG, MW)
            MW.set_Active_PG(PG.PG_CounterVal);
        end
        
        function plotAll(PG)
            for i = 1:PG.AxesCounter
                eval(PG.AxesFunction{PG.AxesCounter});
            end
        end
    end
    
end

