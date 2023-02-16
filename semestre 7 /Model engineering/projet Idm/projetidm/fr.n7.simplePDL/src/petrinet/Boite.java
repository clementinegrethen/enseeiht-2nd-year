/**
 */
package petrinet;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Boite</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.Boite#getLinksToSuccessors <em>Links To Successors</em>}</li>
 *   <li>{@link petrinet.Boite#getLinksToPredecessors <em>Links To Predecessors</em>}</li>
 *   <li>{@link petrinet.Boite#getName <em>Name</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getBoite()
 * @model abstract="true"
 * @generated
 */
public interface Boite extends PetriElement {
	/**
	 * Returns the value of the '<em><b>Links To Successors</b></em>' reference list.
	 * The list contents are of type {@link petrinet.Arc}.
	 * It is bidirectional and its opposite is '{@link petrinet.Arc#getPredecessor <em>Predecessor</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Links To Successors</em>' reference list.
	 * @see petrinet.PetrinetPackage#getBoite_LinksToSuccessors()
	 * @see petrinet.Arc#getPredecessor
	 * @model opposite="predecessor"
	 * @generated
	 */
	EList<Arc> getLinksToSuccessors();

	/**
	 * Returns the value of the '<em><b>Links To Predecessors</b></em>' reference list.
	 * The list contents are of type {@link petrinet.Arc}.
	 * It is bidirectional and its opposite is '{@link petrinet.Arc#getSuccessor <em>Successor</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Links To Predecessors</em>' reference list.
	 * @see petrinet.PetrinetPackage#getBoite_LinksToPredecessors()
	 * @see petrinet.Arc#getSuccessor
	 * @model opposite="successor"
	 * @generated
	 */
	EList<Arc> getLinksToPredecessors();

	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see petrinet.PetrinetPackage#getBoite_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link petrinet.Boite#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

} // Boite
