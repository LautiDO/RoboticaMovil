
L=zeros(1,21);

clear; clc;

% Inicialización
c = 0:10:200;                      % Posición de las celdas (21 celdas)
L = zeros(1, 21);                 % Log-odds inicial (todas las celdas con probabilidad 0.5)
j=0;

L_libre = log(0.3 / (1 - 0.3));   % Log-odds para libre (antes del obstáculo)
L_ocupado = log(0.6 / (1 - 0.6)); % Log-odds para ocupado (obstáculo cerca)

z1 = [101, 82, 91, 112, 99, 151, 86, 95, 109, 105];  % Mediciones
z2 = [101, 99, 97, 102, 99, 100, 96, 104, 99, 105]; %Mejores mediciones
  
m = 1 - 1 ./ (1 + exp(L));  % Convertir log-odds a probabilidad

% Grafico suposición inicial
bar(c, m);                  
ylim([0 1]);
title(sprintf('Medicion %d', j));
xlabel('Posición (cm)');
ylabel('Probabilidad de ocupación');
pause(0.5);

for j = 1:length(z2)
    med = z2(j);  % Medición actual
    
    for i = 1:21
        if c(i) < med
            L(i) = L(i) + L_libre;
        elseif c(i) < med + 20
            L(i) = L(i) + L_ocupado;
        end
        % No se actualiza si está más allá del obstáculo
    end

    m = 1 - 1 ./ (1 + exp(L));  % Convertir log-odds a probabilidad

    % Graficar paso a paso
    bar(c, m);                   % Usamos c para que el eje X muestre la posición en cm
    ylim([0 1]);
    title(sprintf('Medicion %d', j));
    xlabel('Posición (cm)');
    ylabel('Probabilidad de ocupación');
    pause(0.5);
end

