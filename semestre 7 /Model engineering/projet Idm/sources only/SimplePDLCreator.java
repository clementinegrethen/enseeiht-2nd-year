package simplepdl.manip;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import simplepdl.Process;
import simplepdl.ProcessElement;
import simplepdl.WorkDefinition;
import simplepdl.WorkSequence;
import simplepdl.WorkSequenceType;
import simplepdl.SimplepdlFactory;
import simplepdl.SimplepdlPackage;
import simplepdl.Ressource;
import simplepdl.RessourcesRequise;

public class SimplePDLCreator {

	public static void main(String[] args) {
		
		// Charger le package SimplePDL afin de l'enregistrer dans le registre d'Eclipse.
		SimplepdlPackage packageInstance = SimplepdlPackage.eINSTANCE;
		
		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		
		// CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (le modÃ¨le)
		ResourceSet resSet = new ResourceSetImpl();

		// DÃ©finir la ressource (le modÃ¨le)
		URI modelURI = URI.createURI("models/SimplePDLCreator_Created_Process.xmi");
		Resource resource = resSet.createResource(modelURI);
		
		// La fabrique pour fabriquer les Ã©lÃ©ments de SimplePDL
	    SimplepdlFactory myFactory = SimplepdlFactory.eINSTANCE;

		// CrÃ©er un Ã©lÃ©ment Process
		Process process = myFactory.createProcess();
		process.setName("Procédé ");
		
		// Ajouter le Process dans le modÃ¨le
		resource.getContents().add(process);

		// Ajouter deux WorkDefinitions
	    WorkDefinition wd1 = myFactory.createWorkDefinition();
	    wd1.setName("conception");
	    
	    WorkDefinition wd2 = myFactory.createWorkDefinition();
	    wd2.setName("RedactionDoc");
	    
	    WorkDefinition wd3 = myFactory.createWorkDefinition();
	    wd3.setName("Programmation");
	    
	    WorkDefinition wd4 = myFactory.createWorkDefinition();
	    wd4.setName("RedactionTest");
	    
	    process.getProcessElements().add(wd1);
	    process.getProcessElements().add(wd2);
	    process.getProcessElements().add(wd3);
	    process.getProcessElements().add(wd4);

	    
		// Ajouter une WorkSequence entre les deux WorkDefinitions
	    WorkSequence seq1 = myFactory.createWorkSequence();
	    seq1.setPredecessor(wd1);
	    seq1.setSuccessor(wd2);
	    seq1.setLinkType(WorkSequenceType.START_TO_START);
	    
	    process.getProcessElements().add(seq1);
	    
		// Ajouter une deuxiÃ¨me WorkSequence entre les deux WorkDefinitions
	    WorkSequence seq2 = myFactory.createWorkSequence();
	    seq2.setPredecessor(wd1);
	    seq2.setSuccessor(wd2);
	    seq2.setLinkType(WorkSequenceType.FINISH_TO_FINISH);
	    
	    process.getProcessElements().add(seq2);
	    
	    WorkSequence seq3 = myFactory.createWorkSequence();
	    seq3.setPredecessor(wd1);
	    seq3.setSuccessor(wd3);
	    seq3.setLinkType(WorkSequenceType.FINISH_TO_START);
	    
	    process.getProcessElements().add(seq3);
	    
	    WorkSequence seq4 = myFactory.createWorkSequence();
	    seq4.setPredecessor(wd1);
	    seq4.setSuccessor(wd4);
	    seq4.setLinkType(WorkSequenceType.START_TO_START);
	    
	    process.getProcessElements().add(seq4);
	    
	    WorkSequence seq5 = myFactory.createWorkSequence();
	    seq5.setPredecessor(wd3);
	    seq5.setSuccessor(wd4);
	    seq5.setLinkType(WorkSequenceType.FINISH_TO_FINISH);
	    
	    process.getProcessElements().add(seq5);
	    
	    // définir les ressources disponibles
	    Ressource r1 = myFactory.createRessource();
	    r1.setName("concepteur");
	    r1.setQuantite(3);
	    
	    Ressource r2 = myFactory.createRessource();
	    r2.setName("développeur");
	    r2.setQuantite(2);
	    
	    Ressource r3 = myFactory.createRessource();
	    r3.setName("machine");
	    r3.setQuantite(4);
	    
	    Ressource r4 = myFactory.createRessource();
	    r4.setName("rédacteur");
	    r4.setQuantite(1);
	    
	    Ressource r5 = myFactory.createRessource();
	    r5.setName("testeur");
	    r5.setQuantite(2);
	    
	    process.getProcessElements().add(r1);
	    process.getProcessElements().add(r2);
	    process.getProcessElements().add(r3);
	    process.getProcessElements().add(r4);
	    process.getProcessElements().add(r5);
	    
	    // Définir les ressources requises pour chaque activité
	    RessourcesRequise rcc = myFactory.createRessourcesRequise();
	    rcc.setRessourceutilise(r1);
	    rcc.setNb(2);
	    rcc.setRessourcePredecessor(wd1);
	    
	    RessourcesRequise rmc = myFactory.createRessourcesRequise();
	    rmc.setRessourceutilise(r3);
	    rmc.setNb(2);
	    rmc.setRessourcePredecessor(wd1);
	    
	    RessourcesRequise rmr = myFactory.createRessourcesRequise();
	    rmr.setRessourceutilise(r3);
	    rmr.setNb(1);
	    rmr.setRessourcePredecessor(wd2);
	    
	    RessourcesRequise rrr = myFactory.createRessourcesRequise();
	    rrr.setRessourceutilise(r4);
	    rrr.setNb(1);
	    rrr.setRessourcePredecessor(wd2);
	    
	    RessourcesRequise rdp = myFactory.createRessourcesRequise();
	    rdp.setRessourceutilise(r2);
	    rdp.setNb(2);
	    rdp.setRessourcePredecessor(wd3);
	    
	    RessourcesRequise rmp = myFactory.createRessourcesRequise();
	    rmp.setRessourceutilise(r3);
	    rmp.setNb(3);
	    rmp.setRessourcePredecessor(wd3);
	    
	    RessourcesRequise rmrt = myFactory.createRessourcesRequise();
	    rmrt.setRessourceutilise(r3);
	    rmrt.setNb(2);
	    rmrt.setRessourcePredecessor(wd4);
	    
	    RessourcesRequise rtr = myFactory.createRessourcesRequise();
	    rtr.setRessourceutilise(r5);
	    rtr.setNb(1);
	    rtr.setRessourcePredecessor(wd4);

	    process.getProcessElements().add(rcc);
	    process.getProcessElements().add(rmc);
	    process.getProcessElements().add(rmr);
	    process.getProcessElements().add(rrr);
	    process.getProcessElements().add(rdp);
	    process.getProcessElements().add(rmp);
	    process.getProcessElements().add(rmrt);
	    process.getProcessElements().add(rtr);

	    
	    
		
		// Sauver la ressource
	    try {
	    	resource.save(Collections.EMPTY_MAP);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
