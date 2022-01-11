import org.gradle.api.DefaultTask
import org.gradle.api.file.ConfigurableFileTree
import org.gradle.api.file.DirectoryProperty
import org.gradle.api.file.ProjectLayout
import org.gradle.api.model.ObjectFactory
import org.gradle.api.provider.Property
import org.gradle.api.tasks.CacheableTask
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.InputDirectory
import org.gradle.api.tasks.InputFiles
import org.gradle.api.tasks.Optional
import org.gradle.api.tasks.OutputDirectory
import org.gradle.api.tasks.PathSensitive
import org.gradle.api.tasks.PathSensitivity
import org.gradle.api.tasks.TaskAction
import org.gradle.process.ExecOperations
import javax.inject.Inject

@CacheableTask
abstract class CreateGitTag @Inject constructor(
    private val objects: ObjectFactory,
    private val execOperations: ExecOperations
) : DefaultTask() {

    @get:Input
    val tagName: Property<String> = objects.property(String::class.java)

    @TaskAction
    fun applyArgbash() {
        logger.info("Tagging HEAD as ${tagName.get()}")
        execOperations.exec { execSpec ->
            execSpec.commandLine("git", "tag", "-f", tagName.get())
        }
        execOperations.exec { execSpec ->
            execSpec.commandLine("git", "push", "--tags")
        }
    }
}
