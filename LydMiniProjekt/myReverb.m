function y = myReverb(x, fs, delay, gain)
    % Comb Filters
    combDelay1 = round(0.03 * fs);  % 30 ms delay
    combGain1 = 0.7;
    combDelay2 = round(0.05 * fs);  % 50 ms delay
    combGain2 = 0.5;
    combDelay3 = round(0.07 * fs);  % 70 ms delay
    combGain3 = 0.3;
    combDelay4 = round(0.1 * fs);   % 100 ms delay
    combGain4 = 0.2;
    
    % Allpass filters
    allpassDelay1 = round(delay * fs); % delay for the first all-pass filter
    allpassGain1 = 0.5;
    allpassDelay2 = round(delay * fs); % delay for the second all-pass filter
    allpassGain2 = 0.5;
    
    % Initializing the output signal
    y = x;
    
    % Applying comb filters
    combOutput1 = zeros(size(x));
    combOutput2 = zeros(size(x));
    combOutput3 = zeros(size(x));
    combOutput4 = zeros(size(x));
    for n = max([combDelay1, combDelay2, combDelay3, combDelay4])+1:length(x)
        combOutput1(n) = x(n - combDelay1) + combGain1 * combOutput1(n - combDelay1);
        combOutput2(n) = x(n - combDelay2) + combGain2 * combOutput2(n - combDelay2);
        combOutput3(n) = x(n - combDelay3) + combGain3 * combOutput3(n - combDelay3);
        combOutput4(n) = x(n - combDelay4) + combGain4 * combOutput4(n - combDelay4);
    end
    
    % Combining the comb filter outputs
    combCombinedOutput = combOutput1 + combOutput2 + combOutput3 + combOutput4;
    
    % Applying the all-pass filters
    allpassOutput1 = zeros(size(combCombinedOutput));
    allpassOutput2 = zeros(size(combCombinedOutput));
    for n = allpassDelay1+1:length(combCombinedOutput)
        allpassOutput1(n) = combCombinedOutput(n) + allpassGain1 * allpassOutput1(n - allpassDelay1);
    end
    for n = allpassDelay2+1:length(combCombinedOutput)
        allpassOutput2(n) = allpassOutput1(n) + allpassGain2 * allpassOutput2(n - allpassDelay2);
    end
    
    % Combining all-pass outputs
    allpassCombinedOutput = allpassOutput2;
    
    % Combining the comb and all-pass filters
    y = y + allpassCombinedOutput * gain;
end
