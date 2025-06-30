% Ej 3

bel = [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];

figure;
for i = 1:9
    bel = aplicar_movimiento(bel, 'avanzar');
    bar(0:19, bel);
    ylim([0 1]);
    title(sprintf('Paso %d - avanzar', i));
    xlabel('Celda');
    ylabel('Probabilidad');
    pause(0.5);  % Espera medio segundo entre pasos
end

for i = 1:3
    bel = aplicar_movimiento(bel, 'retroceder');
    bar(0:19, bel);
    ylim([0 1]);
    title(sprintf('Paso %d - retroceder', 9 + i));
    xlabel('Celda');
    ylabel('Probabilidad');
    pause(0.5);  % Espera medio segundo entre pasos
end

% Visualización
figure;
bar(0:19, bel)
xlabel('Celda')
ylabel('Probabilidad')
title('Distribución final de belief después de 9 avanzar + 3 retroceder')


function new_bel = aplicar_movimiento(bel, comando)
        N = length(bel);  % Número total de celdas en el mundo

    % Definir el modelo de movimiento según el comando
    switch comando
        case 'avanzar'
            % Probabilidades asociadas al comando "avanzar":
            % 25% de quedarse, 50% de avanzar 1, 25% de avanzar 2 celdas
            probs = [0.25, 0.5, 0.25];
            desplazamientos = [0, 1, 2];  % Desplazamientos relativos desde la celda actual
        case 'retroceder'
            % Probabilidades similares pero en dirección opuesta
            probs = [0.25, 0.5, 0.25];
            desplazamientos = [0, -1, -2];
    end

    new_bel = zeros(size(bel));  % Inicializamos la nueva creencia en cero

    % Para cada celda actual i (donde el robot podría estar)
    for i = 1:N
        % Para cada posible resultado del modelo de movimiento
        for j = 1:length(probs)
            dest = i + desplazamientos(j);  % Calculamos la celda de destino

            if dest >= 1 && dest <= N
                % Si el destino está dentro del mundo, distribuimos la probabilidad a esa celda
                new_bel(dest) = new_bel(dest) + bel(i) * probs(j);
            else
                % Si el movimiento se sale del mundo, se asume que el robot se queda en su lugar
                new_bel(i) = new_bel(i) + bel(i) * probs(j);
            end
        end
    end
end
