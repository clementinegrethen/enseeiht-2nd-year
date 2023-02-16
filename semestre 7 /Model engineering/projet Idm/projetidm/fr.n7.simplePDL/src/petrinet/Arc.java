/**
 */
package petrinet;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Arc</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.Arc#getPredecessor <em>Predecessor</em>}</li>
 *   <li>{@link petrinet.Arc#getSuccessor <em>Successor</em>}</li>
 *   <li>{@link petrinet.Arc#getNbJetons <em>Nb Jetons</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getArc()
 * @model
 * @generated
 */
public interface Arc extends PetriElement {
	/**
	 * Returns the value of the '<em><b>Predecessor</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link petrinet.Boite#getLinksToSuccessors <em>Links To Successors</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Predecessor</em>' reference.
	 * @see #setPredecessor(Boite)
	 * @see petrinet.PetrinetPackage#getArc_Predecessor()
	 * @see petrinet.Boite#getLinksToSuccessors
	 * @model opposite="linksToSuccessors" required="true"
	 * @generated
	 */
	Boite getPredecessor();

	/**
	 * Sets the value of the '{@link petrinet.Arc#getPredecessor <em>Predecessor</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Predecessor</em>' reference.
	 * @see #getPredecessor()
	 * @generated
	 */
	void setPredecessor(Boite value);

	/**
	 * Returns the value of the '<em><b>Successor</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link petrinet.Boite#getLinksToPredecessors <em>Links To Predecessors</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Successor</em>' reference.
	 * @see #setSuccessor(Boite)
	 * @see petrinet.PetrinetPackage#getArc_Successor()
	 * @see petrinet.Boite#getLinksToPredecessors
	 * @model opposite="linksToPredecessors" required="true"
	 * @generated
	 */
	Boite getSuccessor();

	/**
	 * Sets the value of the '{@link petrinet.Arc#getSuccessor <em>Successor</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Successor</em>' reference.
	 * @see #getSuccessor()
	 * @generated
	 */
	void setSuccessor(Boite value);

	/**
	 * Returns the value of the '<em><b>Nb Jetons</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb Jetons</em>' attribute.
	 * @see #setNbJetons(int)
	 * @see petrinet.PetrinetPackage#getArc_NbJetons()
	 * @model required="true"
	 * @generated
	 */
	int getNbJetons();

	/**
	 * Sets the value of the '{@link petrinet.Arc#getNbJetons <em>Nb Jetons</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb Jetons</em>' attribute.
	 * @see #getNbJetons()
	 * @generated
	 */
	void setNbJetons(int value);

} // Arc
