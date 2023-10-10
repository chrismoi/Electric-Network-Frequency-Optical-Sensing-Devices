function [ enf ] = zeroCrossings( input, Ts )
    %enf using zero crossings method
    lastCrossing = 0;
    interFreqs = [];
    for j = 2:length(input)
        if (input(j) * input(j-1) < 0 || input(j) == 0)
            currentCrossing = -input(j)/(input(j)-input(j-1)) + j;
            if(lastCrossing ~= 0)
                interFreqs = [interFreqs; 0.5/(Ts*(currentCrossing-lastCrossing))];
            end
            lastCrossing = currentCrossing;
        end
    end
    enf = mean(interFreqs);
end

