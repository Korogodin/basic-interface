classdef CControlGroup < handle
    %CCONTROLGROUP Panel of buttons, edits and others
    
    properties
        pan_handle % Handle of panel
        
        Parent 
        Width
        Height
    end
    
    methods
        function CG = CControlGroup(Parent, Position)
            CG.pan_handle = uipanel(Parent, 'Units', 'pixels',  ...
                'BackgroundColor', get(Parent, 'Color'), 'BorderType', 'none');
            set(CG.pan_handle, 'Position', Position);
            CG.Width = Position(3);
            CG.Height = Position(4);
            CG.Parent = Parent;
        end
        
        function hC = addControl(CG, Style, FuncCallback, String)
            hC = uicontrol(CG.pan_handle, 'Style', Style, 'Units', 'pixels', 'Callback', FuncCallback, ...
            'Position', [10 10 50 50], 'String', String);
        end
        
        function hC = addControl2(CG, Style, FuncCallback, String)
            hC = uicontrol(CG.pan_handle, 'Style', Style, 'Units', 'pixels', 'Callback', FuncCallback, ...
            'Position', [60 60 100 100], 'String', String);
        end        
        
    end
    
end

