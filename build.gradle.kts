import java.util.Properties

plugins {
    kotlin("jvm") version "1.6.20"
    id("application")
    id("java")
    id("idea")

    // This is used to create a GraalVM native image
    id("org.graalvm.buildtools.native") version "0.9.11"

    // This creates a fat JAR
    id("com.github.johnrengelman.shadow") version "7.1.2"
}

// load the properties
val properties = Properties().apply {load(file("gradle.properties").inputStream())}

// get version
version = properties.getProperty("version") 


group = "com.ido"
description = "HelloWorld"

application.mainClass.set("com.ido.HelloWorld")

repositories {
    mavenCentral()
}

graalvmNative {
    binaries {
        named("main") {
            imageName.set("helloworld")
            mainClass.set("com.ido.HelloWorld")
            fallback.set(false)
            sharedLibrary.set(false)
            useFatJar.set(true)
            javaLauncher.set(javaToolchains.launcherFor {
                languageVersion.set(JavaLanguageVersion.of(17))
                vendor.set(JvmVendorSpec.matching("GraalVM Community"))
            })
        }
    }
}


tasks.register("incrementPatchVersion") {
    doLast {
        val propertiesFile = file("gradle.properties")
        val properties = Properties().apply {load(propertiesFile.inputStream())}

        val version = properties.getProperty("version")
        val (major, minor, patch) = version.split(".").map { it.toInt() }
        val newVersion = "${major}.${minor}.${patch+1}"

        properties.setProperty("version", newVersion)
        properties.store(propertiesFile.outputStream(), null)

        println("Version updated to $newVersion")
    }
}

tasks.register("getVersion") {
    doLast {
        val propertiesFile = file("gradle.properties")
        val properties = Properties().apply {load(propertiesFile.inputStream())}
        System.out.println(properties.getProperty("version"))
    }
}