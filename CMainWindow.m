classdef CMainWindow < handle 
    %CMainWindow Class of main window of model
    
    properties
        
        % Settings and Consts
        min_window_size = [1024 768];
        BPGP_Height = 50; % Buttons of PG Panel height
        CP_Width = 250; % ControlGroup panel width
        
        % Properties
        win_size;
        handle;
        PG_counter;
        ActivatedPG;
        
        %Other objects
        PG % Plots Groups objects cell array
        CG % Control Panel structure
        BPGP % Buttons of Plots Group Panel
        
    end
    
    methods
        
        function MW = CMainWindow(Name) % Constructor
            MW.handle =  figure('Name', Name, 'Units', 'pixels', 'Resize', 'off', 'NumberTitle', 'off', 'MenuBar', 'figure');
            MW.PG_counter = 0;            
            if MW.initial_config()
                MW.handle = 0;
                return;
            end

        end
        
        function erro = initial_config(MW)
            erro = 0;
            
            % Set size
            scrsz = get(0,'ScreenSize');
            if (scrsz(3) < MW.min_window_size(1)) || (scrsz(4) < MW.min_window_size(2))
                fprintf('Your screen is so small! Minimum resolution is %.0fx%.0f\n', MW.min_window_size(1), MW.min_window_size(2));
                close(MW.handle);
                erro = 1;
                return;
            end
            MW.win_size(1) = scrsz(3)*0.8;
            MW.win_size(2) = scrsz(4)*0.8;
            wx = scrsz(3)/2 - MW.win_size(1)/2;
            wy = scrsz(4)/2 - MW.win_size(2)/2;
            set(MW.handle, 'Position', [wx wy MW.win_size(1) MW.win_size(2)]);
            
            % Create Control Panel
            Position = [MW.win_size(1)-MW.CP_Width, 0, MW.CP_Width, MW.win_size(2)];
            MW.CG = CControlGroup(MW.handle, Position);
            
            % Create Buttons of PG Panel
            MW.BPGP.Height = MW.BPGP_Height;
            MW.BPGP.Position = [0, MW.win_size(2)-MW.BPGP_Height, MW.win_size(1)-MW.CP_Width, MW.win_size(2)];
            MW.BPGP.handle = uipanel(MW.handle, 'Units', 'pixels', 'Position',  MW.BPGP.Position, ...
                'BackgroundColor', get(MW.handle, 'Color'), 'BorderType', 'none');
        end
        
        function setActivePG(MW, num)
            MW.ActivatedPG = num;
            MW.PG{num}.ActiveOn;
            for i = 1:MW.PG_counter
                if i ~= num
                    MW.PG{i}.ActiveOff;
                end
            end
            drawnow;
        end
        
        function num = newPG(MW, Name, ButName, ya, xa) 
            % Create PlotGroups
            MW.PG_counter = MW.PG_counter + 1;
            PG_Position = [5, 5, MW.win_size(1)-MW.CP_Width - 10, MW.win_size(2)-MW.BPGP_Height - 10];
            MW.PG{MW.PG_counter} = CPlotGroup(MW.handle, MW.PG_counter, Name, PG_Position, MW.BPGP, ButName, xa, ya);
            MW.setActivePG(MW.PG_counter);            
            num = MW.PG_counter;
        end
        
        function replot(MW)
            % Draw all axes on actived PG
            MW.PG{MW.ActivatedPG}.plotAll;
            drawnow
            pause(0.01);
        end

    end
    
end

