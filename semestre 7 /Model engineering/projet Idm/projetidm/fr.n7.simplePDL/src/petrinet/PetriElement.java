/**
 */
package petrinet;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Petri Element</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.PetriElement#getReseaupetri <em>Reseaupetri</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getPetriElement()
 * @model abstract="true"
 * @generated
 */
public interface PetriElement extends EObject {
	/**
	 * Returns the value of the '<em><b>Reseaupetri</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link petrinet.ReseauPetri#getPetriElements <em>Petri Elements</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Reseaupetri</em>' container reference.
	 * @see #setReseaupetri(ReseauPetri)
	 * @see petrinet.PetrinetPackage#getPetriElement_Reseaupetri()
	 * @see petrinet.ReseauPetri#getPetriElements
	 * @model opposite="petriElements" required="true" transient="false"
	 * @generated
	 */
	ReseauPetri getReseaupetri();

	/**
	 * Sets the value of the '{@link petrinet.PetriElement#getReseaupetri <em>Reseaupetri</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Reseaupetri</em>' container reference.
	 * @see #getReseaupetri()
	 * @generated
	 */
	void setReseaupetri(ReseauPetri value);

} // PetriElement
