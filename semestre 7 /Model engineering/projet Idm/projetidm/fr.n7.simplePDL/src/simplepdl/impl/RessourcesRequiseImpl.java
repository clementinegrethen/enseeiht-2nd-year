/**
 */
package simplepdl.impl;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import simplepdl.Ressource;
import simplepdl.RessourcesRequise;
import simplepdl.SimplepdlPackage;
import simplepdl.WorkDefinition;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Ressources Requise</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link simplepdl.impl.RessourcesRequiseImpl#getNb <em>Nb</em>}</li>
 *   <li>{@link simplepdl.impl.RessourcesRequiseImpl#getRessourceutilise <em>Ressourceutilise</em>}</li>
 *   <li>{@link simplepdl.impl.RessourcesRequiseImpl#getRessourcePredecessor <em>Ressource Predecessor</em>}</li>
 * </ul>
 *
 * @generated
 */
public class RessourcesRequiseImpl extends MinimalEObjectImpl.Container implements RessourcesRequise {
	/**
	 * The default value of the '{@link #getNb() <em>Nb</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNb()
	 * @generated
	 * @ordered
	 */
	protected static final int NB_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getNb() <em>Nb</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNb()
	 * @generated
	 * @ordered
	 */
	protected int nb = NB_EDEFAULT;

	/**
	 * The cached value of the '{@link #getRessourceutilise() <em>Ressourceutilise</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRessourceutilise()
	 * @generated
	 * @ordered
	 */
	protected Ressource ressourceutilise;

	/**
	 * The cached value of the '{@link #getRessourcePredecessor() <em>Ressource Predecessor</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRessourcePredecessor()
	 * @generated
	 * @ordered
	 */
	protected WorkDefinition ressourcePredecessor;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected RessourcesRequiseImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SimplepdlPackage.Literals.RESSOURCES_REQUISE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getNb() {
		return nb;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setNb(int newNb) {
		int oldNb = nb;
		nb = newNb;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SimplepdlPackage.RESSOURCES_REQUISE__NB, oldNb, nb));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Ressource getRessourceutilise() {
		if (ressourceutilise != null && ressourceutilise.eIsProxy()) {
			InternalEObject oldRessourceutilise = (InternalEObject)ressourceutilise;
			ressourceutilise = (Ressource)eResolveProxy(oldRessourceutilise);
			if (ressourceutilise != oldRessourceutilise) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE, oldRessourceutilise, ressourceutilise));
			}
		}
		return ressourceutilise;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Ressource basicGetRessourceutilise() {
		return ressourceutilise;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRessourceutilise(Ressource newRessourceutilise) {
		Ressource oldRessourceutilise = ressourceutilise;
		ressourceutilise = newRessourceutilise;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE, oldRessourceutilise, ressourceutilise));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public WorkDefinition getRessourcePredecessor() {
		if (ressourcePredecessor != null && ressourcePredecessor.eIsProxy()) {
			InternalEObject oldRessourcePredecessor = (InternalEObject)ressourcePredecessor;
			ressourcePredecessor = (WorkDefinition)eResolveProxy(oldRessourcePredecessor);
			if (ressourcePredecessor != oldRessourcePredecessor) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR, oldRessourcePredecessor, ressourcePredecessor));
			}
		}
		return ressourcePredecessor;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public WorkDefinition basicGetRessourcePredecessor() {
		return ressourcePredecessor;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRessourcePredecessor(WorkDefinition newRessourcePredecessor) {
		WorkDefinition oldRessourcePredecessor = ressourcePredecessor;
		ressourcePredecessor = newRessourcePredecessor;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR, oldRessourcePredecessor, ressourcePredecessor));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case SimplepdlPackage.RESSOURCES_REQUISE__NB:
				return getNb();
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE:
				if (resolve) return getRessourceutilise();
				return basicGetRessourceutilise();
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR:
				if (resolve) return getRessourcePredecessor();
				return basicGetRessourcePredecessor();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case SimplepdlPackage.RESSOURCES_REQUISE__NB:
				setNb((Integer)newValue);
				return;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE:
				setRessourceutilise((Ressource)newValue);
				return;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR:
				setRessourcePredecessor((WorkDefinition)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case SimplepdlPackage.RESSOURCES_REQUISE__NB:
				setNb(NB_EDEFAULT);
				return;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE:
				setRessourceutilise((Ressource)null);
				return;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR:
				setRessourcePredecessor((WorkDefinition)null);
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case SimplepdlPackage.RESSOURCES_REQUISE__NB:
				return nb != NB_EDEFAULT;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCEUTILISE:
				return ressourceutilise != null;
			case SimplepdlPackage.RESSOURCES_REQUISE__RESSOURCE_PREDECESSOR:
				return ressourcePredecessor != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuilder result = new StringBuilder(super.toString());
		result.append(" (nb: ");
		result.append(nb);
		result.append(')');
		return result.toString();
	}

} //RessourcesRequiseImpl
