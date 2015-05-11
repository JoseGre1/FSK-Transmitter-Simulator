function varargout = UIMain(varargin)
% UIMAIN MATLAB code for UIMain.fig
%   Copyright 2015 José Hernández. Andrés Villa.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UIMain_OpeningFcn, ...
                   'gui_OutputFcn',  @UIMain_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before UIMain is made visible.
function UIMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UIMain (see VARARGIN)

% Choose default command line output for UIMain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UIMain wait for user response (see UIRESUME)
% uiwait(handles.UIMain);
global fx Tp fc snr linf lsup delta t Nsamp tao NFFT f B
global check11 check21 check31 check41 check51 check61 check71 check81
global check12 check22 check32 check42 check52 check62 check72 check82
%------------Parámetros de Señales Usadas
%------------Funcion x1(t)(realización del proceso)
fx = 100;
Tp = 1;
%------------Funcion y(t)(salida 
fc = 100e+3;
snr = 10;
%------------Tiempo
linf = -10;
lsup = 10;
delta = 1/(2*fc);
t = linf:delta:lsup;
Nsamp = floor(length(t)*delta);
tao = t;
%------------Frecuencia
NFFT = length(t);
f = -1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT));
%------------Corte del filtro usado(ideal)
B=101;
%------------VALORES INICIALES DE OBJETOS
%------------Poner en 0 los CheckBut
set(handles.Check_Sx1,'Value',0);
set(handles.Check_Sx_WGN1,'Value',0);
set(handles.Check_Sx_WGNF1,'Value',0);
set(handles.Check_X_real1,'Value',0);
set(handles.Check_Ycomp1,'Value',0);
set(handles.Check_Ycomp_WGN1,'Value',0);
set(handles.Check_Ycomp_WGNF1,'Value',0);
set(handles.Check_Y_WGN1,'Value',0);
set(handles.Check_Sx2,'Value',0);
set(handles.Check_Sx_WGN2,'Value',0);
set(handles.Check_Sx_WGNF2,'Value',0);
set(handles.Check_X_real2,'Value',0);
set(handles.Check_Ycomp2,'Value',0);
set(handles.Check_Ycomp_WGN2,'Value',0);
set(handles.Check_Ycomp_WGNF2,'Value',0);
set(handles.Check_Y_WGN2,'Value',0);
%------------Bloquear los CheckBut correspondientes
set(handles.Check_X_real1,'Enable','off');
set(handles.Check_Ycomp1,'Enable','off');
set(handles.Check_Ycomp_WGN1,'Enable','off');
set(handles.Check_Ycomp_WGNF1,'Enable','off');
set(handles.Check_Y_WGN1,'Enable','off');
%------------Bloquear los botonos de Graficar2 y 3 (Frecuencia)
set(handles.But_Graficar2,'Enable','off');
set(handles.But_Graficar3,'Enable','off');
%------------Variables check"ij" para no repetir los cálculos (velocidad)
check11 = 0;
check21 = 0;
check31 = 0;
check41 = 0;
check51 = 0;
check61 = 0;
check71 = 0;
check81 = 0;
check12 = 0;
check22 = 0;
check32 = 0;
check42 = 0;
check52 = 0;
check62 = 0;
check72 = 0;
check82 = 0;



% --- Outputs from this function are returned to the command line.
function varargout = UIMain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in But_Graficar1.
function But_Graficar1_Callback(hObject, eventdata, handles)
% hObject    handle to But_Graficar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fx Tp fc snr tao g_comp_y g_comp_y_wgn y_wgn t
global x1 y Rx
%------------tetha: Distribuido uniformemente entre -pi/2 y pi/2
lim1 = -pi/2;
lim2 = lim1*(-1);
tetha = random('Uniform',lim1,lim2);
%------------Realización del proceso
x1 = rectpuls(t,Tp).*cos(2*pi*fx*t + tetha);
%------------Salida de modulador en cuadratura
y = x1.*cos(2*pi*fc*t)+x1.*sin(2*pi*fc*t);
%------------Señal de salida del modulador con ruido blanco
y_wgn = awgn(y,snr);
%------------Funcion de autocorrelación hallada analíticamente
Rx = (1/2)*cos(2*pi*fx*tao).*rectpuls(t,2*Tp);
%------------Envolvente compleja de y(t)
g_comp_y = x1-1i*x1;
%------------Envolvente compleja de y(t) con ruido blanco
g_comp_y_wgn = awgn(g_comp_y,snr); 
%------------Axes1_Tiempo
axes(handles.Tiempo_Ax1)
plot(t,x1)
grid on
xlim([-Tp/2-(Tp/2)*0.1 Tp/2+(Tp/2)*0.1])
xlabel('Tiempo(t)')
ylabel('x1(t) (Realización)')
%------------Axes2_Tiempo
axes(handles.Tiempo_Ax2)
plot(t,y_wgn)
grid on
xlim([-100/fc 100/fc])
xlabel('Tiempo(t)')
ylabel('y(t) + WGN')
%------------Axes2_Tiempo
axes(handles.Tiempo_Ax3)
plot(tao,Rx)
grid on
xlim([-Tp-Tp*0.1 Tp+Tp*0.1])
xlabel('Tiempo(t)')
ylabel('Rx(t)')
set(handles.But_Graficar2,'Enable','on');
set(handles.But_Graficar3,'Enable','on');
% AxesH = findall(UIMain,'type','axes');
% tj = 0:0.001:1;
% xj = tj.^2;
% for i=1:length(AxesH)
%     axes(AxesH(i))
%     plot(tj,xj)
% end



% --- Executes on button press in Check_Sx2.
function Check_Sx2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx2


% --- Executes on button press in Check_Sx_WGN2.
function Check_Sx_WGN2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx_WGN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx_WGN2


% --- Executes on button press in Check_Sx_WGNF2.
function Check_Sx_WGNF2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx_WGNF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx_WGNF2


% --- Executes on button press in Check_X_real2.
function Check_X_real2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_X_real2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_X_real2


% --- Executes on button press in Check_Ycomp2.
function Check_Ycomp2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp2


% --- Executes on button press in Check_Ycomp_WGN2.
function Check_Ycomp_WGN2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp_WGN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp_WGN2


% --- Executes on button press in Check_Ycomp_WGNF2.
function Check_Ycomp_WGNF2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp_WGNF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp_WGNF2


% --- Executes on button press in Check_Y_WGN2.
function Check_Y_WGN2_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Y_WGN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Y_WGN2


% --- Executes on button press in Check_Sx1.
function Check_Sx1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx1


% --- Executes on button press in Check_Sx_WGN1.
function Check_Sx_WGN1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx_WGN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx_WGN1


% --- Executes on button press in Check_Sx_WGNF1.
function Check_Sx_WGNF1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Sx_WGNF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Sx_WGNF1


% --- Executes on button press in Check_X_real1.
function Check_X_real1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_X_real1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_X_real1


% --- Executes on button press in Check_Ycomp1.
function Check_Ycomp1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp1


% --- Executes on button press in Check_Ycomp_WGN1.
function Check_Ycomp_WGN1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp_WGN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp_WGN1


% --- Executes on selection change in Menu_tipo.
function Menu_tipo_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_tipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tipo = get(handles.Menu_tipo,'Value');
set(handles.Check_Sx1,'Value',0);
set(handles.Check_Sx_WGN1,'Value',0);
set(handles.Check_Sx_WGNF1,'Value',0);
set(handles.Check_X_real1,'Value',0);
set(handles.Check_Ycomp1,'Value',0);
set(handles.Check_Ycomp_WGN1,'Value',0);
set(handles.Check_Ycomp_WGNF1,'Value',0);
set(handles.Check_Y_WGN1,'Value',0);
switch Tipo
    case 1
        set(handles.Check_Sx1,'Enable','on');
        set(handles.Check_Sx_WGN1,'Enable','on');
        set(handles.Check_Sx_WGNF1,'Enable','on');
        set(handles.Check_X_real1,'Enable','off');
        set(handles.Check_Ycomp1,'Enable','off');
        set(handles.Check_Ycomp_WGN1,'Enable','off');
        set(handles.Check_Ycomp_WGNF1,'Enable','off');
        set(handles.Check_Y_WGN1,'Enable','off');
    case 2
        set(handles.Check_Sx1,'Enable','off');
        set(handles.Check_Sx_WGN1,'Enable','off');
        set(handles.Check_Sx_WGNF1,'Enable','off');
        set(handles.Check_X_real1,'Enable','on');
        set(handles.Check_Ycomp1,'Enable','off');
        set(handles.Check_Ycomp_WGN1,'Enable','off');
        set(handles.Check_Ycomp_WGNF1,'Enable','off');
        set(handles.Check_Y_WGN1,'Enable','off');
    case 3
        set(handles.Check_Sx1,'Enable','off');
        set(handles.Check_Sx_WGN1,'Enable','off');
        set(handles.Check_Sx_WGNF1,'Enable','off');
        set(handles.Check_X_real1,'Enable','off');
        set(handles.Check_Ycomp1,'Enable','on');
        set(handles.Check_Ycomp_WGN1,'Enable','on');
        set(handles.Check_Ycomp_WGNF1,'Enable','on');
        set(handles.Check_Y_WGN1,'Enable','off');
    case 4
        set(handles.Check_Sx1,'Enable','off');
        set(handles.Check_Sx_WGN1,'Enable','off');
        set(handles.Check_Sx_WGNF1,'Enable','off');
        set(handles.Check_X_real1,'Enable','off');
        set(handles.Check_Ycomp1,'Enable','off');
        set(handles.Check_Ycomp_WGN1,'Enable','off');
        set(handles.Check_Ycomp_WGNF1,'Enable','off');
        set(handles.Check_Y_WGN1,'Enable','on');
end




% Hints: contents = cellstr(get(hObject,'String')) returns Menu_tipo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu_tipo


% --- Executes during object creation, after setting all properties.
function Menu_tipo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_tipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Check_Ycomp_WGNF1.
function Check_Ycomp_WGNF1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Ycomp_WGNF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Ycomp_WGNF1


% --- Executes on button press in Check_Y_WGN1.
function Check_Y_WGN1_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Y_WGN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Y_WGN1


% --- Executes on button press in But_Reset.
function But_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to But_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf);
UIMain;

% --- Executes on button press in But_Graficar3.
function But_Graficar3_Callback(hObject, eventdata, handles)
% hObject    handle to But_Graficar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1 NFFT t X1 Nsamp Sx f fx g_comp_y g_comp_y_wgn snr
global Sgr Sr Va Ur Sxr Sxrf Hfs G_COMP_Y G_COMP_Y_WGN X_ruido
global check11 check21 check31 check41 check51 check61 check71 check81
global check12 check22 check32 check42 check52 check62 check72 check82
global color1 color2 color3 color4 color5 color6 color7 color8
global G_COMP_Y_WGN_FIL Hf B y_wgn Y_WGN fc
%------------Definicion de colores para las gráficas
h = zeros(8);
color1 = [1 0 1];
color2 = [0.8 1 0];
color3 = [0.3 0.5 0.9];
color4 = [0 0 1];
color5 = [0 1 0];
color6 = [0 1 1];
color7 = [1 0.7 0];
color8 = [0.6 0 0.5];
%------------Graficar en el axes 2 de frecuencias
axes(handles.Frec_Ax2)
cont = 0; %------------Contador para verificacion de seleccion de check
%------------Comprobación de cálculos previos
%------------CHECK 1
%------------CHECK 1
if(get(handles.Check_Sx2,'Value')==1)
    if check11 == 0
        %------------PSD hallada analíticamente
        Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
        check12 = 1;
    end
    %------------Graficar el espectro actual
    h(1) = plot(f,Sx,'Color',color1);
    grid on
    xlim([-fx-5 fx+5])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 2
%------------CHECK 2
if(get(handles.Check_Sx_WGN2,'Value')==1)
    if check21 == 0
        if check11 == 0 && check12==0
            %------------PSD hallada analíticamente
            Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
        end
        %------------Ruido Potencia
        X_ruido= awgn(x1,snr);
        Sgr=pwelch(X_ruido);
        Sr=Sgr-pwelch(x1);
        Va=var(Sr);
        Ur=mean(Sr);
        %------------PSD DEL PROCESO CON RUIDO
        Sxr=Sx+Ur;
        check22 = 1;
    end
    %------------Graficar el espectro actual
    h(2) = plot(f,Sxr,'Color',color2);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 3
%------------CHECK 3
if(get(handles.Check_Sx_WGNF2,'Value')==1)
    if check31 == 0
        if (check22 == 0 && check12==0)
            if check12==0 && check11==0
                %------------PSD hallada analíticamente
                Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
            end
            %------------Ruido Potencia
            X_ruido= awgn(x1,snr);
            Sgr=pwelch(X_ruido);
            Sr=Sgr-pwelch(x1);
            Va=var(Sr);
            Ur=mean(Sr);
            %------------PSD DEL PROCESO CON RUIDO
            Sxr=Sx+Ur;
            check21 = 1;
            check22 = 1;
        end
        %------------filtro para la PSD
        B1=100+(1/2);
        U3=zeros(1,length(Sxr));
        U3(f>-B1)=1;
        U4=zeros(1,length(Sxr));
        U4(f>B1)=1;
        Hfs=U3-U4;
        %-------------PSD con ruido Filtrada
        Sxrf=Sxr.*(Hfs).^2;
        check32 = 1;
    end
    %------------Graficar el espectro actual
    h(3) = plot(f,Sxrf,'Color',color3);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 4
%------------CHECK 4
if(get(handles.Check_X_real2,'Value')==1)
    if check41 == 0
        X1 = abs(fft(x1,NFFT)/length(t));
        X1 = fftshift(X1);
        check42 = 1;
    end
    %------------Graficar el espectro actual
    h(4) = plot(f,X1*Nsamp,'Color',color4);
    grid on
    xlim([-fx-5 fx+5])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;    
end
%------------CHECK 5
%------------CHECK 5
if(get(handles.Check_Ycomp2,'Value')==1)
    if check51 == 0
        if (check62==0 && check61==0)
            g_comp_y = x1-1i*x1;
        end
        G_COMP_Y = abs(fft(g_comp_y,NFFT)/length(t));
        G_COMP_Y = fftshift(G_COMP_Y);
        check52 = 1;
    end
    %------------Graficar el espectro actual
    h(5) = plot(f,G_COMP_Y*Nsamp,'Color',color5);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 6
%------------CHECK 6
if(get(handles.Check_Ycomp_WGN2,'Value')==1)
    if check61 == 0
        if (check52==0 && check51==0)
            g_comp_y = x1-1i*x1;
        end
        g_comp_y_wgn = awgn(g_comp_y,snr);   
        G_COMP_Y_WGN = abs(fft(g_comp_y_wgn,NFFT)/length(t));
        G_COMP_Y_WGN = fftshift(G_COMP_Y_WGN);
        check62 = 1;
    end
    %------------Graficar el espectro actual
    h(6) = plot(f,G_COMP_Y_WGN*Nsamp,'Color',color6);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 7
%------------CHECK 7
if(get(handles.Check_Ycomp_WGNF2,'Value')==1)
    if check71 == 0
        if (check62==0 && check61==0)
            if(check52==0 && check51==0)
                g_comp_y = x1-1i*x1;
            end
            g_comp_y_wgn = awgn(g_comp_y,snr);
            G_COMP_Y_WGN = abs(fft(g_comp_y_wgn,NFFT)/length(t));
            G_COMP_Y_WGN = fftshift(G_COMP_Y_WGN);
        end
        U1=zeros(1,length(G_COMP_Y_WGN));
        U1(f>-B)=1;
        U2=zeros(1,length(G_COMP_Y_WGN));
        U2(f>B)=1;
        Hf=U1-U2;
        G_COMP_Y_WGN_FIL=(1/2)*(G_COMP_Y_WGN.*Hf);
        check72 = 1;
    end
     %------------Graficar el espectro actual
    h(7) = plot(f,G_COMP_Y_WGN_FIL*Nsamp,'Color',color7);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    %------------Contador para verificacion de seleccion de check
    cont = cont + 1;
end
%------------CHECK 8
%------------CHECK 8
if(get(handles.Check_Y_WGN2,'Value')==1)
    if check81 == 0
        Y_WGN = abs(fft(y_wgn,NFFT)/length(t));
        Y_WGN = fftshift(Y_WGN);
    end
    h(8) = plot(f,Y_WGN*Nsamp,'Color',color8);
    grid on
    xlim([-fc-fc*0.1 fc+fc*0.1])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
end
legend(handles.Frec_Ax2,[h(1),h(2),h(3),h(4),h(5),h(6),h(7),h(8)],...
       '1','2','3','4','5','6','7','8','Location','NorthEastOutside');
hold off

% --- Executes on button press in But_Graficar2.
function But_Graficar2_Callback(hObject, eventdata, handles)
% hObject    handle to But_Graficar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Csx Sx f fx check11 check12 Csx_r check21 check22 Ur Sxr Csx_r_f Sxrf fc
global check31 check32 Hfs Crea check41 check42 NFFT t x1 X1 Nsamp Cenvco y_wgn Y_WGN
global check51 check52 g_comp_y G_COMP_Y Cenvco_ru G_COMP_Y_WGN g_comp_y_wgn check61 check62
global snr Sgr Sr Cenvco_ru_f check71 check72 G_COMP_Y_WGN_FIL Hf Cyr_f check81 check82
Csx=get(handles.Check_Sx1,'Value');
Csx_r=get(handles.Check_Sx_WGN1,'Value'); 
Csx_r_f=get(handles.Check_Sx_WGNF1,'Value'); 
Crea=get(handles.Check_X_real1,'Value'); 
Cenvco=get(handles.Check_Ycomp1,'Value'); 
Cenvco_ru=get(handles.Check_Ycomp_WGN1,'Value'); 
Cenvco_ru_f=get(handles.Check_Ycomp_WGNF1,'Value'); 
Cyr_f=get(handles.Check_Y_WGN1,'Value'); 
h=zeros(8);
axes(handles.Frec_Ax1)
if Csx==1
    if check12==0 && check11==0;
        Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
    end 
h(1) = plot(f,Sx,'Color',[1 0 1]);
grid on
xlim([-fx-5 fx+5])
ylabel('Magnitud')
xlabel('Frecuencia(f)')
hold on
check11=1;
end
if Csx_r==1
    if check22==0 && check21==0
        %------------Ruido Potencia
        X_ruido= awgn(x1,snr);
        Sgr=pwelch(X_ruido);
        Sr=Sgr-pwelch(x1);
        Va=var(Sr);
        Ur=mean(Sr);
        if check11==0 && check12==0
            Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
        end
        %------------PSD DEL PROCESO CON RUIDO
        Sxr=Sx+Ur;
    end
    h(2) = plot(f,Sxr,'Color',[0.8 1 0]);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
check21=1;
end 
if Csx_r_f==1
    if check32==0 && check31==0
        %------------filtro para la PSD
        B1=100+(1);
        U3=zeros(1,length(Sxr));
        U3(f>-B1)=1;
        U4=zeros(1,length(Sxr));
        U4(f>B1)=1;
        Hfs=U3-U4;
        %--------------------------------
        if check22==0 && check21==0
            %------------Ruido Potencia
            X_ruido= awgn(x1,snr);
            Sgr=pwelch(X_ruido);
            Sr=Sgr-pwelch(x1);
            Va=var(Sr);
            Ur=mean(Sr);
            if check11==0 && check12==0
                Sx = abs((1/2)*(sinc(2*(f-fx))+sinc(2*(f+fx))));
            end
            %------------PSD DEL PROCESO CON RUIDO
            Sxr=Sx+Ur;
        end
        %-------------PSD con ruido Filtrada
        Sxrf=Sxr.*(Hfs).^2;
    end
h(3) = plot(f,Sxrf,'Color',[0.3 0.5 0.9]);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
check31=1;
end
if Crea==1
    if check42==0 && check41==0
        X1 = abs(fft(x1,NFFT)/length(t));
        X1 = fftshift(X1);
    end
h(4) = plot(f,X1*Nsamp,'Color',[0 0 1]);
grid on
xlim([-fx-5 fx+5])
ylabel('Magnitud')
xlabel('Frecuencia(f)')
hold on
check41=1;
end
if Cenvco==1 
    if check52==0 && check51==0
        G_COMP_Y = abs(fft(g_comp_y,NFFT)/length(t));
        G_COMP_Y = fftshift(G_COMP_Y);
    end
h(5) = plot(f,G_COMP_Y*Nsamp,'Color',[0 1 0]);
grid on
xlim([-fx-8 fx+8])
ylabel('Magnitud')
xlabel('Frecuencia(f)')
hold on
check51=1;
end
if Cenvco_ru==1
    if check62==0 && check61==0
        G_COMP_Y_WGN = abs(fft(g_comp_y_wgn,NFFT)/length(t));
        G_COMP_Y_WGN = fftshift(G_COMP_Y_WGN);
    end
h(6) = plot(f,G_COMP_Y_WGN*Nsamp,'Color',[0 1 1]);
grid on
xlim([-fx-8 fx+8])
ylabel('Magnitud')
xlabel('Frecuencia(f)')
hold on
check61=1;
end
if Cenvco_ru_f==1 
    if check71==0 && check72==0
        if check62==0 && check61==0
            G_COMP_Y_WGN = abs(fft(g_comp_y_wgn,NFFT)/length(t));
            G_COMP_Y_WGN = fftshift(G_COMP_Y_WGN);
        end
        B=101;
        U1=zeros(1,length(G_COMP_Y_WGN));
        U1(f>-B)=1;
        U2=zeros(1,length(G_COMP_Y_WGN));
        U2(f>B)=1;
        Hf=U1-U2;
        G_COMP_Y_WGN_FIL=(1/2)*(G_COMP_Y_WGN.*Hf);
    end
    h(7) = plot(f,G_COMP_Y_WGN_FIL*Nsamp,'Color',[1 0.7 0]);
    grid on
    xlim([-fx-8 fx+8])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    check71=1;
end
if Cyr_f==1 
    if check81==0 && check82==0
        Y_WGN = abs(fft(y_wgn,NFFT)/length(t));
        Y_WGN = fftshift(Y_WGN);
    end
    h(8) = plot(f,Y_WGN*Nsamp,'Color',[0.6 0 0.5]);
    grid on
    xlim([-fc-fc*0.1 fc+fc*0.1])
    ylabel('Magnitud')
    xlabel('Frecuencia(f)')
    hold on
    check81=1;
end
legend(handles.Frec_Ax1,[h(1),h(2),h(3),h(4),h(5),h(6),h(7),h(8)],...
       '1','2','3','4','5','6','7','8','Location','NorthEastOutside');
hold off
