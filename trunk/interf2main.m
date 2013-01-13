% This is example of use
try 
    close(MW.handle); % Close old output form
end

addpath([pwd '/basic-interface']); % Functions for interface

MW = CMainWindow('Name of project');
if MW.handle == 0
    clear MW;
    return;
end