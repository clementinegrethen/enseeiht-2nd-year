import javax.annotation.processing.*;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.*;
import java.util.*;
import javax.tools.Diagnostic.Kind;

/** Check that a class marked {@code @Utility} is indeed a utility class. */
@SupportedAnnotationTypes("Utility")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class UtilityProcessor extends AbstractProcessor {

	@Override
	public boolean process(
			Set<? extends TypeElement> annotations,
			RoundEnvironment roundingEnvironment)
	{
		Messager messager = processingEnv.getMessager();
		messager.printMessage(Kind.NOTE,
				"UtilityProcessor executed.");
		//messager.printMessage(Kind.WARNING,
				//"The provided UtilityProcessor class is wrong.  Correct it!");
		for (TypeElement te : annotations) {
			for (Element elt : roundingEnvironment.getElementsAnnotatedWith(te)) {
				if (elt.getKind() != ElementKind.CLASS && elt.getKind() != ElementKind.INTERFACE) {
					messager.printMessage(Kind.ERROR,
							"Only classes can be annotated with @Utility");
				} else {
					if (!elt.getModifiers().contains(Modifier.FINAL)) {
						messager.printMessage(Kind.ERROR,
								"Utility classes must be final");
					}
					
					// Constructors must be private 
					for (Element enclosed : elt.getEnclosedElements()) {
						if (enclosed.getKind() == ElementKind.CONSTRUCTOR) {
							if (enclosed.getModifiers().contains(Modifier.PUBLIC)) {
								messager.printMessage(Kind.ERROR,
										"Utility classes must not have public constructors");
							}
						}
					}
					// methods must be static 
					for (Element enclosed : elt.getEnclosedElements()) {
						if (enclosed.getKind() == ElementKind.METHOD) {
							if (!enclosed.getModifiers().contains(Modifier.STATIC)) {
								messager.printMessage(Kind.ERROR,
										"Utility classes must not have non-static methods");
							}
						}
					}
				}
			
			}
		}
		return true;

	}

}
