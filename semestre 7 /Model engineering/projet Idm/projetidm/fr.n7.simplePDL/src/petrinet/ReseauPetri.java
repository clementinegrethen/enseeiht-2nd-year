/**
 */
package petrinet;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Reseau Petri</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.ReseauPetri#getName <em>Name</em>}</li>
 *   <li>{@link petrinet.ReseauPetri#getPetriElements <em>Petri Elements</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getReseauPetri()
 * @model
 * @generated
 */
public interface ReseauPetri extends EObject {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see petrinet.PetrinetPackage#getReseauPetri_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link petrinet.ReseauPetri#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Petri Elements</b></em>' containment reference list.
	 * The list contents are of type {@link petrinet.PetriElement}.
	 * It is bidirectional and its opposite is '{@link petrinet.PetriElement#getReseaupetri <em>Reseaupetri</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Petri Elements</em>' containment reference list.
	 * @see petrinet.PetrinetPackage#getReseauPetri_PetriElements()
	 * @see petrinet.PetriElement#getReseaupetri
	 * @model opposite="reseaupetri" containment="true"
	 * @generated
	 */
	EList<PetriElement> getPetriElements();

} // ReseauPetri
