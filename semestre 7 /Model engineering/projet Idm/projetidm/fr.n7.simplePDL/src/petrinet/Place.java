/**
 */
package petrinet;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Place</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.Place#getNbJetons <em>Nb Jetons</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getPlace()
 * @model
 * @generated
 */
public interface Place extends Boite {
	/**
	 * Returns the value of the '<em><b>Nb Jetons</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb Jetons</em>' attribute.
	 * @see #setNbJetons(int)
	 * @see petrinet.PetrinetPackage#getPlace_NbJetons()
	 * @model required="true"
	 * @generated
	 */
	int getNbJetons();

	/**
	 * Sets the value of the '{@link petrinet.Place#getNbJetons <em>Nb Jetons</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb Jetons</em>' attribute.
	 * @see #getNbJetons()
	 * @generated
	 */
	void setNbJetons(int value);

} // Place
