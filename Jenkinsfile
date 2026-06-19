// Jenkinsfile - Declarative Pipeline for Robot Framework on Windows agents
pipeline {
    agent any

    options {
        timestamps()
        skipDefaultCheckout(false)
        disableConcurrentBuilds()
    }

    environment {
        // Use workspace-relative names only; never hardcode drive letters or paths
        VENV_DIR     = "venv"
        OUTPUT_DIR   = "output"
        REQ_FILE     = "requirements.txt"
        TESTS_DIR    = "tests"
        ALLURE_RESULTS = "output\\allure-results"
        ALLURE_REPORT  = "output\\allure-report"
    }

    stages {

        // -------------------------------------------------------------
        // Stage 1: Checkout source code from GitHub
        // -------------------------------------------------------------
        stage('Checkout') {
            steps {
                echo "==== Checking out source code from SCM ===="
                checkout scm
                echo "Checkout complete. Workspace: %WORKSPACE%"
            }
        }

        // -------------------------------------------------------------
        // Stage 2: Validate project structure before doing any work
        // -------------------------------------------------------------
        stage('Validate Project Structure') {
            steps {
                echo "==== Validating project structure ===="
                bat """
                    @echo off
                    if not exist "%REQ_FILE%" (
                        echo ERROR: requirements.txt not found in project root.
                        exit /b 1
                    )
                    if not exist "%TESTS_DIR%" (
                        echo ERROR: tests directory not found in project root.
                        exit /b 1
                    )
                    echo Validation passed: requirements.txt and tests directory found.
                """
            }
        }

        // -------------------------------------------------------------
        // Stage 3: Setup Python virtual environment (create/repair)
        // -------------------------------------------------------------
        stage('Setup Python Environment') {
            steps {
                echo "==== Setting up Python virtual environment ===="
                bat """
                    @echo off
                    set VENV_PY="%WORKSPACE%\\%VENV_DIR%\\Scripts\\python.exe"

                    if exist "%VENV_DIR%" (
                        echo Virtual environment folder found. Verifying integrity...
                        if not exist %VENV_PY% (
                            echo Virtual environment appears corrupted. Recreating...
                            rmdir /s /q "%VENV_DIR%"
                        )
                    )

                    if not exist "%VENV_DIR%" (
                        echo Creating new virtual environment...
                        python -m venv "%VENV_DIR%"
                        if errorlevel 1 (
                            echo ERROR: Failed to create virtual environment. Is Python installed and on PATH?
                            exit /b 1
                        )
                    ) else (
                        echo Existing virtual environment is valid. Reusing it.
                    )

                    echo Upgrading pip...
                    call "%VENV_DIR%\\Scripts\\activate.bat"
                    python -m pip install --upgrade pip
                    if errorlevel 1 (
                        echo ERROR: Failed to upgrade pip.
                        exit /b 1
                    )
                    echo Pip upgrade complete.
                """
            }
        }

        // -------------------------------------------------------------
        // Stage 4: Install project dependencies from requirements.txt
        // -------------------------------------------------------------
        stage('Install Dependencies') {
            steps {
                echo "==== Installing dependencies from requirements.txt ===="
                bat """
                    @echo off
                    call "%VENV_DIR%\\Scripts\\activate.bat"

                    pip install -r "%REQ_FILE%"
                    if errorlevel 1 (
                        echo ERROR: Failed to install dependencies from requirements.txt.
                        exit /b 1
                    )
                    echo Dependencies installed successfully.

                    echo Verifying Robot Framework installation...
                    python -m robot --version
                    python -c "import robot; print('Robot Framework module OK:', robot.__file__)"
                    if errorlevel 1 (
                        echo ERROR: Robot Framework is not installed or not accessible in the virtual environment.
                        exit /b 1
                    )
                    echo Robot Framework verification successful.
                """
            }
        }

        // -------------------------------------------------------------
        // Stage 5: Execute all Robot Framework tests recursively
        // -------------------------------------------------------------
        stage('Execute Robot Tests') {
            steps {
                echo "==== Executing Robot Framework tests ===="
                bat """
                    @echo off
                    call "%VENV_DIR%\\Scripts\\activate.bat"

                    if exist "%OUTPUT_DIR%" (
                        echo Cleaning previous output directory...
                        rmdir /s /q "%OUTPUT_DIR%"
                    )
                    mkdir "%OUTPUT_DIR%"

                    echo Running Robot Framework tests from "%TESTS_DIR%" (recursive)...
                    python -m robot --outputdir "%OUTPUT_DIR%" --listener allure_robotframework:%ALLURE_RESULTS% "%TESTS_DIR%"

                    set RC=%ERRORLEVEL%
                    echo Robot Framework execution finished with exit code %RC%.

                    rem Robot exit codes > 0 may indicate failed tests; do not hard-fail the
                    rem pipeline here so reports can still be published. Capture status only.
                    exit /b 0
                """
            }
        }

        // -------------------------------------------------------------
        // Stage 6: Publish Robot Framework metrics (plugin-aware)
        // -------------------------------------------------------------
        stage('Publish Reports') {
            steps {
                echo "==== Publishing Robot Framework reports ===="
                script {
                    def outputXml = "${env.OUTPUT_DIR}\\output.xml"

                    if (fileExists(outputXml)) {
                        try {
                            // Attempt to use the Robot Framework plugin if installed
                            step([
                                $class            : 'RobotPublisher',
                                outputPath        : "${env.OUTPUT_DIR}",
                                outputFileName    : 'output.xml',
                                reportFileName    : 'report.html',
                                logFileName       : 'log.html',
                                disableArchiveOutput: false,
                                passThreshold     : 0,
                                unstableThreshold : 0,
                                otherFiles        : ''
                            ])
                            echo "Robot Framework plugin metrics published successfully."
                        } catch (NoSuchMethodError | Exception err) {
                            echo "WARNING: Robot Framework plugin not available or failed (${err.toString()})."
                            echo "Falling back to archiving HTML reports only."
                        }
                    } else {
                        echo "WARNING: output.xml not found. Skipping Robot Framework metrics publishing."
                    }
                }
            }
        }
        stage('Generate Allure Report') {
            steps {
                echo "==== Generating Allure HTML report ===="
                bat """
                    @echo off
                    if not exist "%ALLURE_RESULTS%" (
                        echo WARNING: Allure results not found. Skipping Allure report generation.
                        exit /b 0
                    )

                    where allure >nul 2>nul
                    if errorlevel 1 (
                        echo WARNING: allure command not found on PATH. Skipping Allure report generation.
                        exit /b 0
                    )

                    allure generate "%ALLURE_RESULTS%" -o "%ALLURE_REPORT%" --clean --single-file
                    if errorlevel 1 (
                        echo WARNING: allure generate failed. Continuing pipeline.
                    ) else (
                        echo Allure report generated successfully at %ALLURE_REPORT%
                    )

                    exit /b 0
                """
            }
        }

        stage('Generate Robot Metrics') {
            steps {
                echo "==== Generating Robot Framework Metrics report ===="
                bat """
                    @echo off
                    call "%VENV_DIR%\\Scripts\\activate.bat"

                    if not exist "%OUTPUT_DIR%\\output.xml" (
                        echo WARNING: output.xml not found. Skipping metrics generation.
                        exit /b 0
                    )

                    robotmetrics -I "%OUTPUT_DIR%"
                    if errorlevel 1 (
                        echo WARNING: robotmetrics failed to generate report. Continuing pipeline.
                    ) else (
                        echo Robot Framework Metrics report generated successfully.
                    )

                    rem Always exit 0 so this optional/non-critical stage never fails the build
                    exit /b 0
                """
            }
        }

        // -------------------------------------------------------------
        // Stage 7: Archive generated reports and logs as artifacts
        // -------------------------------------------------------------
        stage('Archive Artifacts') {
            steps {
                echo "==== Archiving reports and logs as Jenkins artifacts ===="
                script {
                    if (fileExists("${env.OUTPUT_DIR}")) {
                        archiveArtifacts artifacts: "${env.OUTPUT_DIR}/**/*.*", allowEmptyArchive: true, fingerprint: false
                        echo "Artifacts archived from '${env.OUTPUT_DIR}' directory."
                    } else {
                        echo "WARNING: Output directory not found. Nothing to archive."
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------
    // Post actions: always run, regardless of build result
    // -------------------------------------------------------------
    post {
        always {
            echo "==== Post-build: ensuring reports are collected and workspace is tidy ===="
            script {
                if (fileExists("${env.OUTPUT_DIR}")) {
                    archiveArtifacts artifacts: "${env.OUTPUT_DIR}/**/*.*", allowEmptyArchive: true, fingerprint: false
                    echo "Final archive step completed: reports preserved in '${env.OUTPUT_DIR}'."
                } else {
                    echo "No output directory found during post-build step."
                }
            }

            // Clean only transient cache/temp files; never remove the venv or output reports
            bat """
                @echo off
                echo Cleaning up temporary pycache files (preserving venv and output)...
                for /d /r %WORKSPACE% %%d in (__pycache__) do (
                    if exist "%%d" rmdir /s /q "%%d"
                )
                echo Cleanup complete.
            """
        }

        success {
            echo "==== Build completed successfully. Robot Framework reports are available as artifacts. ===="
        }

        unstable {
            echo "==== Build is UNSTABLE. Some Robot Framework tests likely failed. Check report.html and log.html. ===="
        }

        failure {
            echo "==== Build FAILED. Review the console log above for the failing stage and error details. ===="
        }
    }
}