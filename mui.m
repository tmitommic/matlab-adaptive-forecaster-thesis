function varargout = mui(varargin)
%MUI M-file for mui.fig
%      MUI, by itself, creates a new MUI or raises the existing
%      singleton*.
%
%      H = MUI returns the handle to a new MUI or the handle to
%      the existing singleton*.
%
%      MUI('Property','Value',...) creates a new MUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to mui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MUI('CALLBACK') and MUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mui

% Last Modified by GUIDE v2.5 29-Jan-2017 19:02:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mui_OpeningFcn, ...
                   'gui_OutputFcn',  @mui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before mui is made visible.
function mui_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for mui
handles.output = hObject;

movegui('north');
handles.makeStationary=0;
handles.algorithm='LMS';
handles.prepareForecast=1;
handles.whichforecast=1;
handles.alpha=0.000001;
handles.lambda=0.95;
handles.gamma=1;
handles.delta=20;
handles.L=20;
handles.ImportOnlyLast = 0;
set(handles.text_pwdLocation,'String',[ pwd '\dane'])

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = mui_OutputFcn(hObject, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);


% --- Executes on button press in popupmenu_algorithm.
function popupmenu_algorithm_Callback(hObject, ~, handles)
% hObject    handle to popupmenu_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of popupmenu_algorithm
val = get(hObject,'Value');
str = get(hObject, 'String');
handles.algorithm=str{val};
switch handles.algorithm
        case 'LMS'
            set(handles.text_alpha,'Visible','on')
            set(handles.edit_alpha,'Visible','on')  
            set(handles.text_lambda,'Visible','off')
            set(handles.edit_lambda,'Visible','off')
            set(handles.text_gamma,'Visible','off')
            set(handles.edit_gamma,'Visible','off')
        case 'NLMS'
            set(handles.text_alpha,'Visible','on')
            set(handles.edit_alpha,'Visible','on')  
            set(handles.text_lambda,'Visible','off')
            set(handles.edit_lambda,'Visible','off')
            set(handles.text_gamma,'Visible','off')
            set(handles.edit_gamma,'Visible','off')
        case 'RLS'
            set(handles.edit_lambda,'String',num2str(1))
            handles.lambda = 1;     % w RLS lambda zawsze = 1
            set(handles.edit_lambda,'Enable','off')
            set(handles.text_alpha,'Visible','off')
            set(handles.edit_alpha,'Visible','off')
            set(handles.text_lambda,'Visible','on')
            set(handles.edit_lambda,'Visible','on')
            set(handles.text_gamma,'Visible','on')
            set(handles.edit_gamma,'Visible','on')
        case 'EWRLS'
            lambda=0.95;            % przyk³adowa wartoœæ
            set(handles.edit_lambda,'String',num2str(lambda))
            handles.lambda = lambda;  
            set(handles.edit_lambda,'Enable','on')
            set(handles.text_alpha,'Visible','off')
            set(handles.edit_alpha,'Visible','off')
            set(handles.text_lambda,'Visible','on')
            set(handles.edit_lambda,'Visible','on')
            set(handles.text_gamma,'Visible','on')
            set(handles.edit_gamma,'Visible','on')          
        otherwise
            warning('Unexpected algorithm selected.')
end
guidata(hObject, handles);

function edit_importDays_Callback(hObject, ~, handles)
% hObject    handle to edit_importDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_importDays as text
%        str2double(get(hObject,'String')) returns contents of edit_importDays as a double
handles.daysImported=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_importDays_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_importDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.daysImported=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes on button press in checkbox_ImportOnlyLast.
function checkbox_ImportOnlyLast_Callback(hObject, ~, handles)
% hObject    handle to checkbox_ImportOnlyLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ImportOnlyLast
handles.ImportOnlyLast = get(hObject,'Value');
% errordlg(num2str(handles.ImportOnlyLast),'title','modal')
guidata(hObject, handles);

function edit_lagMA_Callback(hObject, ~, handles)
% hObject    handle to edit_lagMA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lagMA as text
%        str2double(get(hObject,'String')) returns contents of edit_lagMA as a double
handles.LagMA=str2num(get(hObject,'String'));
% zmieniono LagMA, wiec nalezy narysowaæ ponownie wykres zmienionego
% szeregu czasowego po usunieciu trendu ta metoda
cla
plot(handles.datynotowan,handles.notowania)
dateaxis('x',1)                                                            %zmiana opisu osi x na daty
grid on
xlabel('Date')
ylabel(' ')
title(['Chart of: ' handles.filename(1:(size(handles.filename,2)-4))])
handles.MA=tsmovavg(handles.notowania,'s',handles.LagMA,1);
handles.notowaniaStac=handles.notowania-handles.MA;    
handles.notowaniaStac=handles.notowaniaStac(handles.LagMA:end);            % obcinany jest poczatek wektorow (NaN)
handles.datynotowanStac=handles.datynotowan(handles.LagMA:end);            %
hold on
plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
axis tight
hold on
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_lagMA_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_lagMA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.LagMA=str2num(get(hObject,'String'));
guidata(hObject, handles);

function edit_alpha_Callback(hObject, ~, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double
handles.alpha=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.alpha=str2double(get(hObject,'String'));
guidata(hObject, handles);

function edit_lambda_Callback(hObject, ~, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lambda as text
%        str2double(get(hObject,'String')) returns contents of edit_lambda as a double
handles.lambda=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_lambda_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.lambda=str2double(get(hObject,'String'));
guidata(hObject, handles);


function edit_gamma_Callback(hObject, ~, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gamma as text
%        str2double(get(hObject,'String')) returns contents of edit_gamma as a double
handles.gamma=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_gamma_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.gamma=str2double(get(hObject,'String'));
guidata(hObject, handles);

function edit_delay_Callback(hObject, ~, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_delay as a double
handles.delta=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.delta=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes on button press in pushbutton_openXLSFile.
function pushbutton_openXLSFile_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_openXLSFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filename=uigetfile('./dane/*.xls','Open prepared .xls file');
cla                                                                        %clear axes
loadDataFromXLS;                                                           
plot(handles.datynotowan,handles.notowania)
axis tight
dateaxis('x',1)                                                            %zmiana opisu osi x na daty
grid on
xlabel('Date')
ylabel(' ')
title(['Chart of: ' handles.filename(1:(size(handles.filename,2)-4))])
dynamicDateTicks
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, ~, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in checkbox_prepareForecast.
function checkbox_prepareForecast_Callback(hObject, ~, handles)
% hObject    handle to checkbox_prepareForecast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_prepareForecast
handles.prepareForecast=get(hObject,'Value');
guidata(hObject, handles);

function edit_ForecastLength_Callback(hObject, ~, handles)
% hObject    handle to edit_ForecastLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ForecastLength as text
%        str2double(get(hObject,'String')) returns contents of edit_ForecastLength as a double
handles.forecastLength=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ForecastLength_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_ForecastLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.forecastLength=str2num(get(hObject,'String'));
guidata(hObject, handles);

function edit_IntervalLength_Callback(hObject, ~, handles)
% hObject    handle to edit_ForecastLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ForecastLength as text
%        str2double(get(hObject,'String')) returns contents of edit_ForecastLength as a double
handles.intervalLength=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_IntervalLength_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_ForecastLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.intervalLength=str2num(get(hObject,'String'));
guidata(hObject, handles);

function edit_L_Callback(hObject, ~, handles)
% hObject    handle to edit_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_L as text
%        str2double(get(hObject,'String')) returns contents of edit_L as a double
handles.L=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_L_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.L=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes on button press in pushbutton_SuggestMinMSEDelay.
function pushbutton_SuggestMinMSEDelay_Callback(hObject, ~, handles)       % *experimental function that can help to determine for what delay MSE is the smallest
% hObject    handle to pushbutton_SuggestMinMSEDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N=length(handles.notowaniaStac);
for delta=1:N/4
    switch handles.algorithm
        case 'LMS'
            [ ~,~,~,MSE(delta) ] = lms1_d(handles.notowaniaStac',handles.L,handles.alpha,delta);
        case 'NLMS'
            [ ~,~,~,MSE(delta) ] = nlms1_d(handles.notowaniaStac',handles.L,handles.alpha,delta);    
        case 'RLS'
            [ ~,~,~,MSE(delta) ] = rls1_d(handles.notowaniaStac',handles.L,handles.lambda,handles.gamma,delta);            
        case 'EWRLS'
            [ ~,~,~,MSE(delta) ] = ewrls1_d(handles.notowaniaStac',handles.L,handles.lambda,handles.gamma,delta);          
        otherwise
            warning('Unexpected algorithm selected.')
    end
end
figure
plot(1:delta,MSE)
[minval,minidx]=min(MSE);
xlabel('delta (delay) [samples]')
ylabel('MSE')
title('MSE as delay function')
set(handles.edit_delay,'String',num2str(minidx));
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_stationarise.
function popupmenu_stationarise_Callback(hObject, ~, handles)
% hObject    handle to popupmenu_stationarise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_stationarise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_stationarise
handles.stationarityMethod=get(hObject,'Value');
switch handles.stationarityMethod
    case 1 %'none - non-processed input data'
        set(handles.edit_lagMA,'Visible','off')                            % some frontend effects - showing MA Lag edit field only for function that uses it
        set(handles.text_lagMA,'Visible','off')                            %
        handles.notowaniaStac=handles.notowania;
        handles.datynotowanStac=handles.datynotowan;
    case 2 %'differencing'
        set(handles.edit_lagMA,'Visible','off')                            %
        set(handles.text_lagMA,'Visible','off')                            %
        handles.notowaniaStac=diff(handles.notowania);
        handles.datynotowanStac=handles.datynotowan(2:end);
        hold on
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
        hold on
    case 3 %'detrending (data - MA)'
        set(handles.edit_lagMA,'Visible','on')                             %
        set(handles.text_lagMA,'Visible','on')                             %
        handles.MA=tsmovavg(handles.notowania,'s',handles.LagMA,1);
        handles.notowaniaStac=handles.notowania-handles.MA;    %
        handles.notowaniaStac=handles.notowaniaStac(handles.LagMA:end);    % obcinany jest poczatek wektorow (NaN)
        handles.datynotowanStac=handles.datynotowan(handles.LagMA:end);    %
        hold on
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
        hold on
    case 4 %'logarithming'
        set(handles.edit_lagMA,'Visible','off')                            %
        set(handles.text_lagMA,'Visible','off')                            %
        handles.notowaniaStac=log10(handles.notowania);
        handles.datynotowanStac=handles.datynotowan;
        hold on
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
        hold on
    otherwise
        warning('Unexpected stationarization method.');
end
axis tight
dynamicDateTicks
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_stationarise_CreateFcn(hObject, ~, handles)
% hObject    handle to popupmenu_stationarise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.stationarityMethod=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in pushbutton_CleanChart.
function pushbutton_CleanChart_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_CleanChart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%     dzienprognozy=datenum(handles.year,handles.month,handles.day);
%     ostatnidziennotowan=handles.datynotowan(size(handles.datynotowan,1));
%     set(handles.priceondaytext,'String','n/a');
cla
plot(handles.datynotowan,handles.notowania)
hold on
switch handles.stationarityMethod
    case 1 %'none - non-processed input data'
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
    case 2 %'differencing'
        plot(handles.datynotowanStac(2:end),handles.notowaniaStac,'r:')
    case 3 %'detrending (data - MA)'
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
    case 4 %'logarithming'
        plot(handles.datynotowanStac,handles.notowaniaStac,'r:')
    otherwise
        warning('Unexpected stationarization method.');
end
hold on
dateaxis('x',1)                                                             %zmiana opisu osi x na daty
grid off
grid on
xlabel('Date')
ylabel(' ')
title(['Chart of: ' handles.filename(1:(size(handles.filename,2)-4))])
axis tight
dynamicDateTicks
guidata(hObject, handles);


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.text_ForecastMSEValue,'String','n/a')
    set(handles.text_ForecastSqrtMSEValue,'String','n/a')
    switch handles.algorithm
        case 'LMS'
            [ ~,ysig,~,handles.MSE ] = lms1_d(handles.notowaniaStac',handles.L,handles.alpha,handles.delta);
        case 'NLMS'
            [ ~,ysig,~,handles.MSE ] = nlms1_d(handles.notowaniaStac',handles.L,handles.alpha,handles.delta);
        case 'RLS'
            [ ~,ysig,~,handles.MSE ] = rls1_d(handles.notowaniaStac',handles.L,handles.lambda,handles.gamma,handles.delta);
        case 'EWRLS'
            [ ~,ysig,~,handles.MSE ] = ewrls1_d(handles.notowaniaStac',handles.L,handles.lambda,handles.gamma,handles.delta);
        otherwise
            warning('Unexpected algorithm selected.')
    end
    handles.ysig=ysig;
    hold on
    switch handles.stationarityMethod                                      % po przetworzeniu szeregu przez filtr adaptacyjny nalezy wykonac operacje odwrtona
                                                                           % w sensie matematycznym do tej wykonanej w celu stacjonaryzacji szeregu
        case 1 %'none - non-processed input data'
           handles.outsig=ysig;
           handles.datynotowanStac=handles.datynotowan;
           plot(handles.datynotowanStac,handles.outsig,'g')
        case 2 %'differencing' 
            handles.outsig=cumsum([handles.notowania(1) ysig])';
            handles.datynotowanStac=handles.datynotowan; %(2:end);
            plot(handles.datynotowanStac,handles.outsig,'g')
        case 3 %'detrending (data - MA)'
            handles.outsig=handles.MA(handles.LagMA:end)+ysig';
            plot(handles.datynotowanStac,handles.outsig,'g')
        case 4 %'logarithming'
            handles.outsig=10.^(ysig);
            plot(handles.datynotowanStac,handles.outsig,'g')
        otherwise
            warning('Unexpected stationarization method.');
    end
    hold on
    % Przygotowanie prognozy:
    if handles.prepareForecast == 1
        if handles.whichforecast == 1
            ns=handles.notowaniaStac;                                              % lokalna kopia wektora zestacjonaryzowanych danych wejœciowych tylko na potrzeby prognozy
            for j=1:handles.forecastLength
                switch handles.algorithm
                    case 'LMS'
                        [ ~,ysig,ff,handles.MSEf ] = lms1_d(ns',handles.L,handles.alpha,handles.delta);
                    case 'NLMS'
                        [ ~,ysig,ff,handles.MSEf ] = nlms1_d(ns',handles.L,handles.alpha,handles.delta);
                    case 'RLS'
                        [ ~,ysig,ff,handles.MSEf ] = rls1_d(ns',handles.L,handles.lambda,handles.gamma,handles.delta);
                    case 'EWRLS'
                        [ ~,ysig,ff,handles.MSEf ] = ewrls1_d(ns',handles.L,handles.lambda,handles.gamma,handles.delta);
                    otherwise
                        warning('Unexpected algorithm selected.');
                end
                forecastedSegmentLast = filter(ff(:,end),1,ns((end-handles.L+1):end));      % przefiltruj sygna³ wejœciowy przez filtr o wspó³czynnikach powsta³ych w wyniku adaptacji
                ns = [ ns; forecastedSegmentLast(end) ];                                    % doklej ostatni¹ próbkê z wyjœcia filtru jako ostatni¹ próbkê wektora wejœciowego
            end
            forecast = ns((end-handles.forecastLength+1):end);
            hold on
            handles.datyPrognoz=(handles.datynotowan(end)+handles.intervalLength):handles.intervalLength:(handles.datynotowan(end)+handles.forecastLength*handles.intervalLength);
            switch handles.stationarityMethod                              % po przetworzeniu szeregu przez filtr adaptacyjny nale¿y wykonaæ operacjê odwrton¹
                                                                           % w sensie matematycznym do tej wykonanej w celu stacjonaryzacji szeregu
                case 1 %'none - non-processed input data'
                    handles.forecast=forecast;
                case 2 %'differencing'
                    %handles.forecast=cumsum([handles.outsig(end) forecast'])';         
                    handles.forecast=cumsum([handles.notowania(end) forecast'])';       %
                    handles.forecast=handles.forecast(2:end);
                case 3 %'detrending (data - MA)'
                    handles.forecast=forecast+handles.MA(end);
                case 4 %'logarithming'
                    handles.forecast=10.^(forecast);
                otherwise
                    warning('Unexpected stationarization method.');
            end
            plot(handles.datyPrognoz,handles.forecast','m')
            hold on
        else % handles.whichforecast == 0 - backtest:
            ns=handles.notowaniaStac(1:(length(handles.notowaniaStac)-handles.forecastLength));     % lokalna kopia skróconego wektora zestacjonaryzowanych danych wejœciowych tylko na potrzeby prognozy
            for j=1:handles.forecastLength
                switch handles.algorithm
                    case 'LMS'
                        [ ~,ysig,ff,handles.MSEf ] = lms1_d(ns',handles.L,handles.alpha,handles.delta);
                    case 'NLMS'
                        [ ~,ysig,ff,handles.MSEf ] = nlms1_d(ns',handles.L,handles.alpha,handles.delta);
                    case 'RLS'
                        [ ~,ysig,ff,handles.MSEf ] = rls1_d(ns',handles.L,handles.lambda,handles.gamma,handles.delta);
                    case 'EWRLS'
                        [ ~,ysig,ff,handles.MSEf ] = ewrls1_d(ns',handles.L,handles.lambda,handles.gamma,handles.delta);
                    otherwise
                        warning('Unexpected algorithm selected.');
                end
                forecastedSegmentLast = filter(ff(:,end),1,ns((end-handles.L+1):end));      % przefiltruj sygna³ wejœciowy przez filtr o wspó³czynnikach powsta³ych w wyniku adaptacji
                ns = [ ns; forecastedSegmentLast(end) ];                                    % doklej ostatni¹ próbkê z wyjœcia filtru jako ostatni¹ próbkê wektora wejœciowego
            end
            forecast = ns((end-handles.forecastLength+1):end);
            handles.forecastsave=forecast;
            hold on
            handles.datyPrognoz=handles.datynotowan((end-handles.forecastLength+1):1:end);
            switch handles.stationarityMethod                              % po przetworzeniu szeregu przez filtr adaptacyjny nalezy wykonac operacje odwrtona
                                                                           % w sensie matematycznym do tej wykonanej w celu stacjonaryzacji szeregu
                case 1 %'none - non-processed input data'
                    handles.forecast=forecast;
                case 2 %'differencing'
                    handles.forecast=cumsum([handles.notowania(end-handles.forecastLength) forecast'])';      %
                    handles.forecast=handles.forecast(2:end);
                case 3 %'detrending (data - MA)'
                    handles.forecast=forecast+handles.MA(end-handles.forecastLength);
                case 4 %'logarithming'
                    handles.forecast=10.^(forecast);
                otherwise
                    warning('Unexpected stationarization method.');
            end
            if handles.whichforecast==1     %forward
                plot(handles.datyPrognoz,handles.forecast','m')
            else
                plot(handles.datyPrognoz,handles.forecast','k')
            end
            hold on
            ForecastMSEValue=sum((handles.notowania((end-handles.forecastLength+1):end)-handles.forecast).^2)/handles.forecastLength;
            set(handles.text_ForecastMSEValue,'String',ForecastMSEValue)
            set(handles.text_ForecastSqrtMSEValue,'String',sqrt(ForecastMSEValue))
            switch handles.algorithm
                    case 'LMS'
                        handles.badaniaLMSe=abs(handles.notowania((end-handles.forecastLength+1):end)-handles.forecast);
                    case 'NLMS'
                        handles.badaniaNLMSe=abs(handles.notowania((end-handles.forecastLength+1):end)-handles.forecast);
                    case 'RLS'
                        handles.badaniaRLSe=abs(handles.notowania((end-handles.forecastLength+1):end)-handles.forecast);
                    case 'EWRLS'
                        handles.badaniaEWRLSe=abs(handles.notowania((end-handles.forecastLength+1):end)-handles.forecast);
                    otherwise
                        warning('Unexpected algorithm selected.');
            end
        end
    end
    % koniec prognozowania
    assignin('base', 'GUIDataStructure', handles);                         % przekazanie struktury handles do workspace
    axis tight
    dateaxis('x',1)                                                        % zmiana opisu osi x na daty
    grid off
    %xlabel('Date')
    ylabel(' ')
    title(['Chart of: ' handles.filename(1:(size(handles.filename,2)-4))])
    if handles.prepareForecast == 1
        legend('Input data','Stationarised data','System output','Forecast','Location','NorthWest')
    else
        legend('Input data','Stationarised data','System output','Location','NorthWest')
    end
    set(handles.text_MSEValue,'String',handles.MSE)
    set(handles.text_SqrtMSEValue,'String',sqrt(handles.MSE))
    refresh
    lim = axis;      % pobierz wektor granic wyswietlanego wykresu
    axis([handles.datynotowan(1) handles.datyPrognoz(end) lim(3) lim(4)])   %od najstarszej próbki sygna³u do najnowszej próbki prognozy, os y bez zmian
    grid on
    dynamicDateTicks
guidata(hObject, handles);

% --- Executes when selected object is changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.whichforecast=1;
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_forwardForecast'
        handles.whichforecast=1;
    case 'radiobutton_backwardForecast'
        handles.whichforecast=0;
end
guidata(hObject, handles);
