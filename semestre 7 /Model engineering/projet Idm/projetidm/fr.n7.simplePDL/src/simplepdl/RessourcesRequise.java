/**
 */
package simplepdl;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Ressources Requise</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link simplepdl.RessourcesRequise#getNb <em>Nb</em>}</li>
 *   <li>{@link simplepdl.RessourcesRequise#getRessourceutilise <em>Ressourceutilise</em>}</li>
 *   <li>{@link simplepdl.RessourcesRequise#getRessourcePredecessor <em>Ressource Predecessor</em>}</li>
 * </ul>
 *
 * @see simplepdl.SimplepdlPackage#getRessourcesRequise()
 * @model
 * @generated
 */
public interface RessourcesRequise extends ProcessElement {
	/**
	 * Returns the value of the '<em><b>Nb</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb</em>' attribute.
	 * @see #setNb(int)
	 * @see simplepdl.SimplepdlPackage#getRessourcesRequise_Nb()
	 * @model required="true"
	 * @generated
	 */
	int getNb();

	/**
	 * Sets the value of the '{@link simplepdl.RessourcesRequise#getNb <em>Nb</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb</em>' attribute.
	 * @see #getNb()
	 * @generated
	 */
	void setNb(int value);

	/**
	 * Returns the value of the '<em><b>Ressourceutilise</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Ressourceutilise</em>' reference.
	 * @see #setRessourceutilise(Ressource)
	 * @see simplepdl.SimplepdlPackage#getRessourcesRequise_Ressourceutilise()
	 * @model required="true"
	 * @generated
	 */
	Ressource getRessourceutilise();

	/**
	 * Sets the value of the '{@link simplepdl.RessourcesRequise#getRessourceutilise <em>Ressourceutilise</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Ressourceutilise</em>' reference.
	 * @see #getRessourceutilise()
	 * @generated
	 */
	void setRessourceutilise(Ressource value);

	/**
	 * Returns the value of the '<em><b>Ressource Predecessor</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Ressource Predecessor</em>' reference.
	 * @see #setRessourcePredecessor(WorkDefinition)
	 * @see simplepdl.SimplepdlPackage#getRessourcesRequise_RessourcePredecessor()
	 * @model required="true"
	 * @generated
	 */
	WorkDefinition getRessourcePredecessor();

	/**
	 * Sets the value of the '{@link simplepdl.RessourcesRequise#getRessourcePredecessor <em>Ressource Predecessor</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Ressource Predecessor</em>' reference.
	 * @see #getRessourcePredecessor()
	 * @generated
	 */
	void setRessourcePredecessor(WorkDefinition value);

} // RessourcesRequise
