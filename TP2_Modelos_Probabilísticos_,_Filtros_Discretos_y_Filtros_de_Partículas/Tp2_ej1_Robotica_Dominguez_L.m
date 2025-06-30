%%Ej 1
mu = 1;
sigma2 = 4;

tic;
X1 = normal_suma_uniformes(mu, sigma2);
t_normal_suma_uniformes = toc

tic;
X2 = normal_box_muller(mu, sigma2);
t_normal_box_muller = toc

tic;
X3 = normal_rechazo(mu, sigma2);
t_normal_rechazo = toc

tic;
X4 = normal_inv(mu, sigma2);
t_normal_inv = toc

tic;
X5 = normrnd(mu, sqrt(sigma2), 1000, 1);
t_normrnd = toc

y = linspace(-8,8,100);
F = normpdf(y,mu,sqrt(sigma2));

figure; hold on
histogram(X1, 30, 'normalization', 'pdf');
plot(y,F);
title('Histograma Suma de Uniformes');

figure; hold on
histogram(X2, 30, 'normalization', 'pdf');
plot(y,F);
title('Histograma Box-Muller');

figure; hold on
histogram(X3, 30, 'Normalization', 'pdf');
plot(y,F);
title('Histograma Metodo de Rechazo');


function x = normal_suma_uniformes(mu, sigma2)
    % Genera una muestra de una distribución normal N(mu, sigma2) utilizando el Teorema Central del Límite con 12 uniformes
    
    N=1000; %Numero de muestras
    
    n = 12;  % cantidad de variables uniformes a sumar
    u = rand(n, N);  % 12 variables U(0,1)
    
    % Aplico Teorema Central del Limite
    z = sum(u - 0.5)/(sqrt(n)*sqrt(1/12));
    
    % Transformar a N(mu, sigma2)
    x = mu + sqrt(sigma2) * z;
end

function x = normal_box_muller(mu, sigma2)
    % Genera una muestra de una distribución normal N(mu, sigma2) usando Box-Muller
    N= 1000;    %Numero de muestras
    
    U1 = rand(1,N);  % muestras U(0,1)
    U2 = rand(1,N);  % otras muestras U(0,1)

    % Box-Muller para obtener una N(0,1)
    Z = sqrt(-2*log(U1)).*cos(2*pi*U2);

    % Escalado a N(mu, sigma2)
    x = mu + sqrt(sigma2) * Z;
end

function x = normal_inv(mu, sigma2)
    % Genera una muestra de una distribución normal N(mu, sigma2) utilizando el método de la transformada inversa
    N= 1000;    %Numero de muestras
    
    U = rand(1, N);  % Generamos una muestra uniforme U(0,1)
    
    % Calcular la inversa de la CDF de la normal estándar usando norminv
    Z = norminv(U, 0, 1);  % norminv(U, 0, 1) da una N(0,1)
    
    % Transformamos a N(mu, sigma^2)
    x = mu + sqrt(sigma2) * Z;
end

function x = normal_rechazo(mu, sigma2)
    % Genera una distribución normal N(mu, sigma2) usando el método de rechazo
     
    N=1000;
    
    % Establecer los límites a, b, basados en mu y sigma
    a = mu - 3 * sqrt(sigma2);  % Límite inferior
    b = mu + 3 * sqrt(sigma2);  % Límite superior
    
    % Función de densidad de la distribución normal N(mu, sigma2)
    f = @(x) (1 / (sqrt(2 * pi * sigma2))) * exp(-0.5 * ((x - mu).^2) / sigma2);
    
    % Función de densidad de uniforme U(0,1)
    g = 1 / (b-a);
    
    % Vector para las muestras
    x = zeros(1, N);  
    
    % Generar todas las muestras de la distribución uniforme U(0,1)
    i=1;
    while i<= N
            % Generar todas las muestras de la distribución uniforme U(0,1)
            u = rand;
            y = a + (b - a) * rand();
            if u <= f(y) % / (M*g)
                x(i) = y;  % Aceptar la muestra
                i= i+1;
            end
    end
end
