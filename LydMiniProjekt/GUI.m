function GUI
    % Specify the audio file
    audioFile = 'BareVærDigSelv.mp3';

    % Read the audio file
    [audioData, fs] = audioread(audioFile);
    reverbAudio = audioData;

    % Initialize the figure
    f = figure('Position', [100, 100, 800, 600], 'Name', 'Reverb Effect', 'NumberTitle', 'off', 'CloseRequestFcn', @closeGUI);

    % Initialize audio player
    player = audioplayer(reverbAudio, fs);

    % Play, Stop, Save Buttons
    uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [50, 550, 100, 40], 'Callback', @playButtonCallback);
    uicontrol('Style', 'pushbutton', 'String', 'Stop', 'Position', [200, 550, 100, 40], 'Callback', @stopButtonCallback);
    
    % Delay and Gain Sliders
    uicontrol('Style', 'text', 'Position', [50, 500, 100, 20], 'String', 'Delay');
    delaySlider = uicontrol('Style', 'slider', 'Position', [150, 500, 200, 20], 'Min', 0, 'Max', 1, 'Value', 0.5, 'Callback', @updateReverb);
    uicontrol('Style', 'text', 'Position', [50, 450, 100, 20], 'String', 'Gain');
    gainSlider = uicontrol('Style', 'slider', 'Position', [150, 450, 200, 20], 'Min', 0, 'Max', 1, 'Value', 0.5, 'Callback', @updateReverb);
    
    % Axes for plotting the waveform
    ax = axes('Units', 'pixels', 'Position', [50, 50, 700, 350]);
    
    % Plot original audio
    plot(ax, audioData);
    title(ax, 'Original Audio');
    
    % Play Button Callback
    function playButtonCallback(~, ~)
        if ~isempty(reverbAudio)
            if isplaying(player)
                stop(player);
            end
            player = audioplayer(reverbAudio, fs);
            play(player);
        end
    end

    % Stop Button Callback
    function stopButtonCallback(~, ~)
        if isplaying(player)
            stop(player);
        end
    end

    % Update Reverb Callback
    function updateReverb(~, ~)
        if ~isempty(audioData)
            delay = delaySlider.Value;
            gain = gainSlider.Value;
            reverbAudio = myReverb(audioData, fs, delay, gain);
            plot(ax, reverbAudio);
            title(ax, 'Reverb Audio');
            if isplaying(player)
                stop(player);
                player = audioplayer(reverbAudio, fs);
                play(player);
            end
        end
    end

    % Close GUI Callback
    function closeGUI(~, ~)
        if isplaying(player)
            stop(player);
        end
        delete(f);
    end
end
