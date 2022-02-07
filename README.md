---

## 08/02/22 - Problems and Paradoxes in High-dimensional spaces

[Slides](./220207_Problem_and_paradoxes_in_HDS/main.pdf)

**Abstract**

High-dimensional spaces are strange places, our intuition can often be misleading and our notions of distances uninformative. How can we circumvent these issues and develop useful statistical tools for high-dimensional datasets?

**Further reading**

[Introduction to High-dimensional statistics (Giraud, 2021)](https://www.taylorfrancis.com/books/mono/10.1201/9781003158745/introduction-high-dimensional-statistics-christophe-giraud)

---

## 29/12/21 - VB for high-dimensional survival analysis

[Slides](./211218_Variational_Bayes_for_high_dim_Survival/vb_hds.pdf)

Presentation of "Variational Bayes for high-dimensional proportional hazards models with applications to gene expression variable selection" 

**Abstract**

High-throughput sequencing has led to a wave of innovation in biomedical sciences, offering extraordinary opportunities for prognostic modelling and understanding diseases drivers. However, the high-dimensionality and heterogeneity of large-scale profiling data introduces considerable challenges. We propose an interpretable Bayesian proportional hazards model for prediction and variable selection, referred to as SVB. Our method, based on a mean-field variational approximation, overcomes the high computational cost of MCMC whilst retaining the useful features, providing excellent point estimates and offering a natural mechanism for variable selection via posterior inclusion probabilities. The performance of our proposed method is assessed via extensive simulations and compared against other state-of-the-art Bayesian variable selection methods, demonstrating comparable or better performance. Finally, we demonstrate how the proposed method can be used for variable selection on two transcriptomic datasets with censored survival outcomes, where we identify genes with pre-existing biological interpretations.

**Referenced Packages**

 - https://github.com/mkomod/survival.svb
 - https://github.com/mkomod/survival.ss

Presented at: CMStatistics 2021.

---

## 29/11/21 - Spike-and-Slab priors in Practice

[Slides](./211129_Spike_and_Slab_in_Practice/ssp.pdf)

The practical uses of spike-and-slab priors.

---

## 18/10/21 - An introduction to Spike-and-Slab priors

[Slides](./211015_Intro_to_Spike_and_Slab_priors/issp.pdf)

An introduction to Spike-and-Slab priors with applications to high-dimensional regression.

---

## 11/06/21 - Scalable Non-parametric sampling for Multimodal posteriors with the Posterior Bootstrap

[Slides](./210611_Posterior_Bootstrap/post_boot.pdf)

A presentation of the paper "Scalable Non-parametric sampling for Multimodal posteriors with the Posterior Bootstrap" by Edwin Fong et al., presented to the Imperial CSML reading group.

#### Materials

[Original paper](https://arxiv.org/pdf/1902.03175.pdf)


---

## 26/02/21 - Gaussian Processes for Survival Analysis

[Slides](./210226_Gaussian_Processes/gp_surv.pdf)

A presentation of the paper "Gaussian Processes for Survival Analysis" by Tamara Fernandez et al., presented to the Imperial CSML reading group.

#### Materials

[Original paper](https://arxiv.org/pdf/1611.00817.pdf)


---

## 22/02/21 - Integrating Multi-omics datasets 

[Slides](./210222_Integrating_Multi-Omics/Integrating_Multi-Omics.pdf)

#### Abstract

We integrate radiomic and transcriptomic data from patients with ovariancancer using sparse canonical correlation analysis (sCCA). We demonstrate integration yields prognostic models with greater predictive accuracy in comparison to using radiomics features alone. However, integration does not provide greater predictive accuracy than transcriptomic data alone. Further, we examine network structures providing plausible relational pathways between genes and radiomic features.

#### Supplementary Materials

 - [Full Report](https://raw.githubusercontent.com/mkomod/ovc/master/Integrating%20multi-omics%20with%20sCCA.pdf)
 - [Code Repository](https://github.com/mkomod/ovc)
 - [rCCA Package](https://github.com/mkomod/rcca)

---
