#! /bin/bash

## CORE ONTOLOGY

## Merge core ontology

robot merge --input ~/gitprojects/RDFBones-O/RDFBones-main.owl \
      --input ~/gitprojects/RDFBones-O/FMA-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/RDFBones-ROIs-EntireBoneOrgan.owl \
      --input ~/gitprojects/RDFBones-O/OBI-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/CIDOC-CRM-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/SIO-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/VIVO-RDFBonesSubset.owl \
      --output results/Merged_CoreOntology.owl

## Merge standards palaeopathology category labels into core ontology

robot merge --input results/Merged_CoreOntology.owl \
      --input ../Standards_-_Paleopathology/results/StandardsPatho_CategoryLabels.owl \
      --output results/Merged_StandardsCategoryLabels.owl

## CATEGORY LABELS

robot template --template Template_PhaleronPatho-CategoryLabels.tsv \
      --input results/Merged_StandardsCategoryLabels.owl \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
  --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/phaleron-patho.owl" \
  --output results/phaleron-patho_CategoryLabels.owl

## VALUE SPECIFICATIONS

# Merge category labels and standards palaeopathology value specifications into core ontology

robot merge --input results/Merged_StandardsCategoryLabels.owl \
      --input results/phaleron-patho_CategoryLabels.owl \
      --input ../Standards_-_Paleopathology/results/StandardsPatho_ValueSpecifications.owl \
      --output results/Merged_CategoryLabelsStandardsValueSpecifications.owl

# Create value specifications

robot template --template Template_PhaleronPatho-ValueSpecifications.tsv \
  --input results/Merged_CategoryLabelsStandardsValueSpecifications.owl \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
  --prefix "vivo: http://vivoweb.org/ontology/core#" \
  --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/phaleron-patho.owl" \
  --output results/phaleron-patho_ValueSpecifications.owl

## MEASUREMENT DATA

# Merge value specifications into core ontology

robot merge --input results/Merged_CategoryLabelsStandardsValueSpecifications.owl \
      --input results/phaleron-patho_ValueSpecifications.owl \
      --output results/Merged_ValueSpecifications.owl

# Create measurement data items

robot template --template Template_PhaleronPatho-MeasurementData.tsv \
  --input results/Merged_ValueSpecifications.owl \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
  --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/phaleron-patho.owl" \
  --output results/phaleron-patho_MeasurementData.owl

## DATASETS

# Merge measurement data into core ontology

robot merge --input results/Merged_ValueSpecifications.owl \
      --input results/phaleron-patho_MeasurementData.owl \
      --output results/Merged_MeasurementData.owl

# Create datasets

robot template --template Template_PhaleronPatho-Datasets.tsv \
  --input results/Merged_MeasurementData.owl \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
  --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-pahto/phaleron-patho.owl" \
  --output results/phaleron-patho_Datasets.owl

## PROCESSES and ROLES

# Merge datasets into core ontology

robot merge --input results/Merged_MeasurementData.owl \
      --input results/phaleron-patho_Datasets.owl \
      --output results/Merged_Datasets.owl

# Create processes and roles

robot template --template Template_PhaleronPatho-ProcessesRoles.tsv \
      --input results/Merged_Datasets.owl \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-pahto/phaleron-patho.owl" \
      --output results/phaleron-patho_ProcessesRoles.owl
      

## EXTENSION

robot merge --input results/phaleron-patho_CategoryLabels.owl \
      --input ../Standards_-_Paleopathology/results/StandardsPatho_CategoryLabels.owl \
      --input ../Standards_-_Paleopathology/results/StandardsPatho_ValueSpecifications.owl \
      --input results/phaleron-patho_ValueSpecifications.owl \
      --input results/phaleron-patho_MeasurementData.owl \
      --input results/phaleron-patho_Datasets.owl \
      --input results/phaleron-patho_ProcessesRoles.owl \
      --output results/phaleron-patho.owl

## CORE ONTOLOGY and EXTENSION

robot merge --input results/Merged_CoreOntology.owl \
      --input results/phaleron-patho.owl \
      --output results/RDFBones_phaleron-patho.owl

read -p 'Hit ENTER to exit'
