/**
 */
package petrinet.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EcoreUtil;

import petrinet.PetriElement;
import petrinet.PetrinetPackage;
import petrinet.ReseauPetri;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Petri Element</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link petrinet.impl.PetriElementImpl#getReseaupetri <em>Reseaupetri</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class PetriElementImpl extends MinimalEObjectImpl.Container implements PetriElement {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected PetriElementImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return PetrinetPackage.Literals.PETRI_ELEMENT;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ReseauPetri getReseaupetri() {
		if (eContainerFeatureID() != PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI) return null;
		return (ReseauPetri)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetReseaupetri(ReseauPetri newReseaupetri, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newReseaupetri, PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReseaupetri(ReseauPetri newReseaupetri) {
		if (newReseaupetri != eInternalContainer() || (eContainerFeatureID() != PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI && newReseaupetri != null)) {
			if (EcoreUtil.isAncestor(this, newReseaupetri))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newReseaupetri != null)
				msgs = ((InternalEObject)newReseaupetri).eInverseAdd(this, PetrinetPackage.RESEAU_PETRI__PETRI_ELEMENTS, ReseauPetri.class, msgs);
			msgs = basicSetReseaupetri(newReseaupetri, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI, newReseaupetri, newReseaupetri));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetReseaupetri((ReseauPetri)otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				return basicSetReseaupetri(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				return eInternalContainer().eInverseRemove(this, PetrinetPackage.RESEAU_PETRI__PETRI_ELEMENTS, ReseauPetri.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				return getReseaupetri();
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
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				setReseaupetri((ReseauPetri)newValue);
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
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				setReseaupetri((ReseauPetri)null);
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
			case PetrinetPackage.PETRI_ELEMENT__RESEAUPETRI:
				return getReseaupetri() != null;
		}
		return super.eIsSet(featureID);
	}

} //PetriElementImpl
