allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

 dependencies {
        // ...

        implementation("com.firebaseui:firebase-ui-auth:9.0.0")

        // Required only if Facebook login support is required
        // Find the latest Facebook SDK releases here: https://goo.gl/Ce5L94
        implementation("com.facebook.android:facebook-android-sdk:8.x")
    }
    
    