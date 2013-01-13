classdef CMainWindow < handle 
    %CMainWindow Class of main window of model
    
    properties
        
        % Settings and Consts
        min_window_size = [1024 768];
        Font_Size = 8; % Font size for output interface
        CP_Width = 250; % Control Panel width
        BPGP_Height = 50; % Buttons of PG Panel height
             
        % Properties
        win_size;
        handle;
        PG_counter;
        Activated_PG;
        
        %Other objects
        PG % Plots Groups objects cell array
        CP % Control Panel structure
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
            MW.CP.Position = [MW.win_size(1)-MW.CP_Width, 0, MW.CP_Width, MW.win_size(2)];
            MW.CP.handle = uipanel(MW.handle, 'Units', 'pixels', 'Position',  MW.CP.Position, ...
                'BackgroundColor', get(MW.handle, 'Color'), 'BorderType', 'none');
            
            % Create Buttons of PG Panel
            MW.BPGP.Height = MW.BPGP_Height;
            MW.BPGP.Position = [0, MW.win_size(2)-MW.BPGP_Height, MW.win_size(1)-MW.CP_Width, MW.win_size(2)];
            MW.BPGP.handle = uipanel(MW.handle, 'Units', 'pixels', 'Position',  MW.BPGP.Position, ...
                'BackgroundColor', get(MW.handle, 'Color'), 'BorderType', 'none');
           
            % Create PlotGroups
            MW.PG_counter = MW.PG_counter + 1;
            PG_Name = ['Plot group ' num2str(MW.PG_counter)];
            PG_Position = [5, 5, MW.win_size(1)-MW.CP_Width - 10, MW.win_size(2)-MW.BPGP_Height - 10];
            MW.PG{MW.PG_counter} = CPlotGroup(MW.handle, MW.PG_counter, PG_Name, PG_Position, MW.BPGP);
            MW.set_Active_PG(MW.PG_counter);
          
            % Test
            ArrPlace = zeros(6,6);
            ArrPlace(4:5, 4:5) = 1;
            MW.PG{MW.PG_counter}.newAxes(ArrPlace, 'plot_func1');
        end
        
        function set_Active_PG(MW, num)
            MW.Activated_PG = num;
            MW.PG{num}.ActiveOn;
            for i = 1:MW.PG_counter
                if i ~= num
                    MW.PG{i}.ActiveOff;
                end
            end
            drawnow;
            fprintf('PG %.0f is active now\n', num);
        end

    end
    
end

