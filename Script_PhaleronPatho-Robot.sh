#! /bin/bash
cleanup=0
update=0
build=0
function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temp files"
    echo "    -u          initalize/update submodule"
    echo "    -h -?       print this help"
    echo " "
    
    exit
}

while getopts "bcuh?" opt; do
    case "$opt" in
        c)
            cleanup=1

            ;;
	u)  update=1
	    ;;
	b) build=1
	   ;;       
	?)
	usage
	;;
	h)
	    usage
	    ;;
    esac
done
if [ -z "$1" ]; then
    usage
fi

## SUBMODULES

## check if submodule is initialized

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then
    update=1
    echo "Initializing git submodule"
fi

## Initialize and update git submodule
if  [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi

## DEPENDENCIES

## Change to StandardsPatho directory

cd dependencies/StandardsPatho/

./Script_StandardsPatho-Robot.sh -b -u

cd ../../

## BUILD ONTOLOGY

if [ $build -eq 1 ]; then
    
## CATEGORY LABELS

## Merge standards palaeopathology category labels into core ontology

robot merge --input dependencies/StandardsPatho/results/Merged_CoreOntology.owl \
      --input dependencies/StandardsPatho/results/StandardsPatho_CategoryLabels.owl \
      --output results/Merged_StandardsCategoryLabels.owl

## Create category labels

robot template --template Template_PhaleronPatho-CategoryLabels.tsv \
      --input results/Merged_StandardsCategoryLabels.owl \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/phaleron-patho.owl" \
      --output results/phaleron-patho_CategoryLabels.owl

## VALUE SPECIFICATIONS

## Merge category labels and standards palaeopathology value specifications into core ontology

robot merge --input results/Merged_StandardsCategoryLabels.owl \
      --input results/phaleron-patho_CategoryLabels.owl \
      --input dependencies/StandardsPatho/results/StandardsPatho_ValueSpecifications.owl \
      --output results/Merged_CategoryLabelsStandardsValueSpecifications.owl

## Create value specifications

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

## Merge value specifications into core ontology

robot merge --input results/Merged_CategoryLabelsStandardsValueSpecifications.owl \
      --input results/phaleron-patho_ValueSpecifications.owl \
      --output results/Merged_ValueSpecifications.owl

## Create measurement data items

robot template --template Template_PhaleronPatho-MeasurementData.tsv \
      --input results/Merged_ValueSpecifications.owl \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "standards-si: http://w3id.org/rdfbones/ext/standards-si/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/phaleron-patho.owl" \
      --output results/phaleron-patho_MeasurementData.owl

## DATASETS

## Merge measurement data into core ontology

robot merge --input results/Merged_ValueSpecifications.owl \
      --input results/phaleron-patho_MeasurementData.owl \
      --input dependencies/StandardsPatho/results/StandardsPatho_MeasurementData.owl \
      --output results/Merged_MeasurementData.owl

## Create datasets

robot template --template Template_PhaleronPatho-Datasets.tsv \
      --input results/Merged_MeasurementData.owl \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-pahto/phaleron-patho.owl" \
      --output results/phaleron-patho_Datasets.owl

## PROCESSES and ROLES

## Merge datasets into core ontology

robot merge --input results/Merged_MeasurementData.owl \
      --input results/phaleron-patho_Datasets.owl \
      --output results/Merged_Datasets.owl

## Create processes and roles

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
      --input results/phaleron-patho_ValueSpecifications.owl \
      --input results/phaleron-patho_MeasurementData.owl \
      --input results/phaleron-patho_Datasets.owl \
      --input results/phaleron-patho_ProcessesRoles.owl \
      --output results/phaleron-patho.owl

robot annotate --input results/phaleron-patho.owl \
      --remove-annotations \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-patho/latest/phaleron-patho.owl" \
      --version-iri "http://w3id.org/rdfbones/ext/phaleron-patho/v0-1/phaleron-patho.owl" \
      --annotation owl:versionInfo "0.1" \
      --language-annotation rdfs:label "Pathological investigations for the Phaleron Bioarchaeological Project" en \
      --language-annotation rdfs:comment "This ontology extension only works in combination with the RDFBones core ontology." en \
      --annotation dc:creator "Felix Engel" \
      --annotation dc:contributor "Stefan Schlager" \
      --annotation dc:contributor "Jane E. Buikstra" \
      --annotation dc:contributor "Eleanna Prevedorou" \
      --annotation dc:contributor "Leigh Hayes" \
      --annotation dc:contributor "Jessica Hotaling" \
      --annotation dc:contributor "Hannah Liedl" \
      --annotation dc:contributor "Jessica Rothwell" \
      --language-annotation dc:description "This RDFBones ontology extension implements the Paleopathology Scoring Key and the Paleopathology Data Acquisition Template authored by the Phaleron Bioarchaeological Project." en \
      --language-annotation dc:title "Pathological investigations for the Phaleron Bioarchaeological Project" en \
      --output results/phaleron-patho.owl

## CONSISTENCY TEST

robot reason --reasoner ELK \
      --input results/phaleron-patho.owl \
      -D results/debug.owl

fi

## CLEANUP

rm -r dependencies/StandardsPatho/results

if  [ $cleanup -eq 1 ]; then
	rm results/Merged_StandardsCategoryLabels.owl results/phaleron-patho_CategoryLabels.owl results/Merged_CategoryLabelsStandardsValueSpecifications.owl results/phaleron-patho_ValueSpecifications.owl results/Merged_ValueSpecifications.owl results/phaleron-patho_MeasurementData.owl results/Merged_MeasurementData.owl results/phaleron-patho_Datasets.owl results/Merged_Datasets.owl results/phaleron-patho_ProcessesRoles.owl
fi
