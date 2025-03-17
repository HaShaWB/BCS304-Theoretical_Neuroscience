# BCS304 Theoretical Neuroscience HW1

## Problem 1

A leaky integrate-and-fire model neuron is implemented with a differential equation

$$\tau\frac{dV_{m}(t)}{dt}=(E_{rest}-V_{m}(t))+R\cdot I_{inj}(t)$$ 

Build a code for this model neuron using Euler method as $$V_{m}(t_{n})=V_{m}(t_{n-1})+\frac{dt}{\tau}[(E_{rest}-V_{m}(t_{n-1}))+R\cdot I_{inj}(t)]$$ where $dt$ is integration time step.

Set parameters $E_{rest}=-65$ mV, $\tau=20$ ms, $dt=0.1$ ms, $R=10$ Ω and spike threshold $E_{th}=-55$ mV.

a. Find the value of constant current injected into this neuron, $I_{inj}(t)=I_{c}$ (mA), that results in an average firing rate of 22.0 Hz. Create a sample raster plot of the output spikes for 1sec and explain how you would precisely and efficiently estimate $I_c$.

b. Can you determine the value of Is that induces an average firing of 2.0 Hz? Explain why this is challenging.

c. Estimate the threshold value of the input current $I_o$ at which non-zero firing begins. Explain how would you measure it as accurately as possible.

d. Implement a background noise as a random current added to input current, sampled at each time t from a Gaussian distribution of mean 0 and standard deviation $\sigma_{noise}$. Set the injected current to $I_c = 0$, and adjust the background noise value $\sigma_{noise}$ so that the neuron fires spontaneously at 2.0 Hz. Explain how would you measure $\sigma_{noise}$ as accurately as possible.

e. In d, obtain spike trains from 5 repeated trials, each with T = 1 sec, and create raster plots for these spikes. Estimate the average firing rate for each trial and calculate the variance of firing rate measure based on these observations. 

f. Repeat the process in e, but with T = 10 sec. Discuss the relationship between the average firing rate and the required observation length to accurately estimate the firing rate. 

g. Estimate the new threshold value of input current that initiates neuron spiking in d. Explain how you would measure it as accurately as possible.

h. Estimate the response function of the neuron (i) with and (ii) without background noise above, by varying the injected current $I_c$ from 0 to $I_{max}$ for 10 different values of $I_c$. Plot the two response functions and discuss how you selected the input values to capture the characteristics of these two curves.

i. Choose an input current value $I_{weak}$ between the two threshold values from h. Discuss the neuron's behavior with and without background noise when this input current is applied.