%Ejercicio: Cinemática del sólido rígido.
%
% Se considera un sistema de barras que giran sin rozamiento.
% Una barra AB de longitud a=10cm gira con velocidad angular de 12 [rad/s] en 
% sentido anti horario. A esta barra está unida una barra BC de longitud b=15cm,
% la cual gira libremente. Finalmente el otro extremo de la barra BC está unida
% a la barra CD de longitud c=20cm que posee su otro extremo fijo.
%
% Se pide determinar la posición de las barras en función del tiempo, determinar
% las velocidades de los puntos de unión.

clear all
close all


% Datos
a=10;
b=15;
c=20;
w=12;  %velocidad angular

% Si se desea ver la animación del sistema se debe definit ipeli menor a 0
ipeli=-1;

% Mediante un análisis geométrico determinamos las posiciones de los 
% puntos P1 y P2
function [x1, y1] = pos_pto1(a, wt)
  x1 = a * cos(wt);
  y1 = a * sin(wt);
endfunction


function [x2, y2] = pos_pto2(a, c, pt)
  x2 = a/2 + c - c * cos(pt);
  y2 = c * sin(pt);
endfunction

% Determinamos las posiciones para una vuelta completa, t=[0,2*pi/w]
Nt= 360; %nro de instantes de  tiempo a evaluar
tt= linspace(0,2*pi/w,Nt);
P1= zeros(Nt,2);
P2= zeros(Nt,2);
for i=1:Nt
  wt = w*tt(i);
  
  [x1, y1] = pos_pto1(a, wt);
  
  L     = sqrt( (x1-a/2-c)^2 + y1^2 );
  beta  = acos( (L^2 + c^2 - b^2)/(2*L*c) );
  theta = acos( (L^2 + (a/2+c)^2 - a^2)/(2*L*(a/2+c)) ) * sign(y1);
  
  pt   = beta+theta;
  [x2, y2] = pos_pto2(a, c, pt);

  %Almacenamos las posiciones de los puntos en función de t   
  P1(i,:) = [x1, y1];
  P2(i,:) = [x2, y2];
end

% Trayectorias de los puntos P1 y P2
figure(1);clf
hold on
plot(0,0,'ko','markersize',10,'linewidth',2)
plot(b/2+c,0,'ko','markersize',10,'linewidth',2)
plot(P1(:,1),P1(:,2),'r+')
plot(P2(:,1),P2(:,2),'bx')
hold off

% Posición del punto P2 en función del tiempo
figure(2);clf
hold on
plot(tt,P2(:,1),'r--','linewidth',2)
plot(tt,P2(:,2),'b-','linewidth',2)
hold off
xlabel('t [s]','fontsize',20)
ylabel('posición [cm]','fontsize',20)
h=legend('P_2 - pos X', 'P_2 - pos Y');
xlim([0, 2*pi/w])
set(h,'fontsize',20)  
set(gca,'fontsize',20)  

% Velocidad del punto P2 en función del tiempo
dt=tt(2);

V2=zeros(Nt,2);
V2=[ diff(P2(:,1)), diff(P2(:,2)) ] / dt;

figure(3);clf
hold on
plot(tt(1:Nt-1),V2(:,1),'r--','linewidth',2)
plot(tt(1:Nt-1),V2(:,2),'b-','linewidth',2)
hold off
xlabel('t [s]','fontsize',20)
ylabel('velocidad [cm/s]','fontsize',20)
h=legend('P_2 - vel X', 'P_2 - vel Y','location','southeast');
xlim([0, 2*pi/w])
set(h,'fontsize',20)  
set(gca,'fontsize',20)


while (ipeli<0)
  for i=1:10:Nt
    
    figure(4);clf
    subplot(1,2,1)
    hold on
    plot(P1(1:i,1),P1(1:i,2),'r.','markersize',14)
    plot(P2(1:i,1),P2(1:i,2),'k.','markersize',14)
    plot(0,0,'ko','markersize',14,'linewidth',3)
    plot(a/2+c,0,'ko','markersize',14,'linewidth',3)
    plot(P1(i,1),P1(i,2),'ko','markersize',14,'linewidth',3)
    plot(P2(i,1),P2(i,2),'ko','markersize',14,'linewidth',3)
    plot([0,P1(i,1)],[0,P1(i,2)],'ro-','linewidth',10)
    plot([P1(i,1),P2(i,1)],[P1(i,2),P2(i,2)],'bo-','linewidth',10)
    plot([P2(i,1),a/2+c],[P2(i,2),0],'ko-','linewidth',10)
    axis equal
    xlim([-a,a/2+c])
    ylim([-a,c])
    hold off
    xlabel('x [cm]','fontsize',24)
    ylabel('y [cm]','fontsize',24)
    set(gca,'fontsize',20,'linewidth', 2)
    
    subplot(1,2,2)
    hold on
    plot(tt(1:Nt-1),V2(:,1),'r:','linewidth',3)
    plot(tt(1:Nt-1),V2(:,2),'b-','linewidth',3)
    plot(tt(i),V2(i,1),'ro','markersize',18,'linewidth',3,'markerfacecolor','g')
    plot(tt(i),V2(i,2),'bo','markersize',18,'linewidth',3,'markerfacecolor','g')
    hold off
    xlabel('t [s]','fontsize',24)
    ylabel('velocidad [cm/s]','fontsize',24)
    h=legend('P_2 - vel X', 'P_2 - vel Y','location','southeast');
    xlim([0, 2*pi/w])
    ylim([-170,130])
    set(h,'fontsize',20)  
    set(gca,'fontsize',20,'linewidth', 2)
    
    pause(0.01)
  end
  ipeli=ipeli+1;
end
