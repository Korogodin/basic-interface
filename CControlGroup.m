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
        
        function hC = addControl(CG, Style, FuncCallback, String, Position)
            hC = uicontrol(CG.pan_handle, 'Style', Style, 'Units', 'pixels', 'Callback', FuncCallback, ...
            'Position', Position, 'String', String);
        end
        
    end
    
end

