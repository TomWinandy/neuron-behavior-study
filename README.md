# neuron-behavior-study
 
 The main objective of this project was to study the reactions of a neuron to various stimuli. The mathematical model modeling this neuronal activity (Fitzhugh-Nagumo model) is given by:

![equation](https://latex.codecogs.com/gif.latex?%5Cfrac%7BdV%7D%7Bdt%7D%3DV%3D%5Cfrac%7BV%5E%7B3%7D%7D%7B3%7D-n%5E%7B2%7D&plus;I_%20%7Bapp%7D)

![equation](https://latex.codecogs.com/gif.latex?%5Cfrac%7Bdn%7D%7Bdt%7D%3DV%3D%5Cepsilon%28n_%7B%5Cinfty%7D%28V%29&plus;n_%7B0%7D-n%29)

![equation](https://latex.codecogs.com/gif.latex?n_%7B%5Cinfty%7D%28V%29%3D%5Cfrac%7B2%7D%7B1&plus;e%5E%7B-5V%7D%7D)

This project enabled us to reflect on the possible reactions of a neuron. This project is divided into four major parts,  namely the creation of methods for finding the roots of a function, the implementation of the system of differential equations as well as its resolution, the study of the electrical activity necessary to produce a reaction of the neuron (where we were able for example to observe that the neuron only produces spikes for a small interval of current values) and finally the study of the reaction of the neuron when it is subjected to a current of type "constant by pieces" (where we were able to conclude that there was once again a "threshold intensity", from of which there is production of spikes).
