function [ out_logvar ] = log_variance(input_waveform)
  N = length(input_waveform);
  out_logvar = 0;
  m = exp(mean(input_waveform) + (var(input_waveform).^2)/2);
  v = exp(2*mean(input_waveform) + var(input_waveform).^2)*(exp(var(input_waveform).^2)-1);
  out_logvar = sqrt(log10(v/(m)^2 +1));
end
