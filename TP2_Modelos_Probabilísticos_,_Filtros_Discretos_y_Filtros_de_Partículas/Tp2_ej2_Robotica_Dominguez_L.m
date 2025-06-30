%Ej2
% Parámetros dados
x_t = [2.0; 4.0; pi/2];
u = [pi/4; 0.0; 1.0];
alpha = [0.1; 0.1; 0.01; 0.01];
N = 5000;

% Generar muestras
[x_tmas, y_tmas, tita_tmas] = modelo_movimiento(x_t, u, alpha);

% Graficar las posiciones (x, y)
figure;
plot(x_tmas, y_tmas, '.');
xlabel('x_{t+1}');
ylabel('y_{t+1}');
title('Distribución de muestras del modelo de movimiento');
axis equal;
grid on;


% Función de odometría
function  [xtmas , ytmas , titatmas] = modelo_movimiento(x_t, u, alpha)

    % Cálculo de las varianzas
    sigma2_1 = (alpha(1)*abs(u(1)) + alpha(2)*u(3));
    sigma2_2 = (alpha(3)*u(3) + alpha(4)*(u(1)+u(2)));
    sigma2_3 = (alpha(1)*abs(u(2)) + alpha(2)*u(3));

    % Cálculo de los movimientos
    delta_rot1 = u(1) + normal_suma_uniformes(0, sigma2_1);
    delta_tran = u(3) + normal_suma_uniformes(0, sigma2_2);
    delta_rot2 = u(2) + normal_suma_uniformes(0, sigma2_3);

    % Cálculo de las nuevas posiciones
    c1 = cos(x_t(3) + delta_rot1);
    c2 = sin(x_t(3) + delta_rot1);
 
  
   xtmas = x_t(1) + c1 .* delta_tran;
   ytmas = x_t(2) + c2 .* delta_tran;
   titatmas = x_t(3) + delta_rot1 + delta_rot2;

end


function x = normal_suma_uniformes(mu, sigma2)
    % Genera una muestra de una distribución normal N(mu, sigma2) utilizando el Teorema Central del Límite con 12 uniformes
    
    N=5000; %Numero de muestras
    
    n = 12;  % cantidad de variables uniformes a sumar
    u = rand(n, N);  % 12 variables U(0,1)
    
    % Aplico Teorema Central del Limite
    z = sum(u - 0.5)/(sqrt(n)*sqrt(1/12));
    
    % Transformar a N(mu, sigma2)
    x = mu + sqrt(sigma2) * z;
end
