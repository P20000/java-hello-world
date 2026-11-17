# Java Hello World CI/CD Pipeline

A simple Java application designed to demonstrate Continuous Integration and Continuous Delivery (CI/CD) with Jenkins and GitHub Webhooks.

---

## Project Structure

```
├── pom.xml                                    # Maven configuration & dependencies
├── Jenkinsfile                                # Declarative Jenkins pipeline with webhook trigger
├── README.md                                  # Setup and usage guide
└── src
    ├── main/java/com/example/App.java         # Main Application
    └── test/java/com/example/AppTest.java     # Unit test using JUnit 5
```

---

## Local Development & Testing

### 1. Compile
```bash
mvn clean compile
```

### 2. Run Tests
```bash
mvn test
```

### 3. Package to JAR
```bash
mvn package
```

### 4. Execute Application
```bash
java -jar target/java-hello-world-1.0-SNAPSHOT.jar
# Output: Hello, World!
```

---

## Jenkins CI/CD Setup with GitHub Webhook

### Step 1: Install Required Jenkins Plugins
1. Open Jenkins and navigate to **Manage Jenkins** -> **Plugins** -> **Available plugins**.
2. Search and install:
   - **GitHub plugin** (or **GitHub Integration Plugin**)
   - **Pipeline** plugin suite

### Step 2: Configure Jenkins Pipeline Job
1. In Jenkins dashboard, click **New Item**.
2. Enter a project name (e.g. `java-hello-world-pipeline`), select **Pipeline**, and click **OK**.
3. Under **Build Triggers**, check:
   - `[x]` **GitHub hook trigger for GITScm polling**
4. Under **Pipeline** section:
   - Set **Definition** to: `Pipeline script from SCM`
   - Set **SCM** to: `Git`
   - Enter your **Repository URL**: `https://github.com/<your-username>/<repo-name>.git`
   - Add your Git credentials (if the repository is private).
   - Set **Branch Specifier**: `*/main` (or `*/master`)
   - Set **Script Path**: `Jenkinsfile`
5. Click **Save**.

### Step 3: Configure GitHub Webhook
1. Go to your repository on GitHub.
2. Click **Settings** -> **Webhooks** -> **Add webhook**.
3. Configure settings:
   - **Payload URL**: `http://<YOUR_JENKINS_PUBLIC_IP_OR_DOMAIN>:8080/github-webhook/`  
     *(Note: The trailing slash `/` at the end of `/github-webhook/` is mandatory!)*
   - **Content type**: `application/json`
   - **Which events would you like to trigger this webhook?**: Select **Just the push event**.
   - Check **Active**.
4. Click **Add webhook**.

> **Note for Local Jenkins Instances (`localhost:8080`):**
> GitHub cannot reach `localhost` directly. Use a reverse proxy tunnel like **ngrok** or **smee.io**:
> ```bash
> ngrok http 8080
> ```
> Then set the GitHub webhook Payload URL to:
> `https://<your-subdomain>.ngrok-free.app/github-webhook/`

---

## Managing Webhook via GitHub CLI (`gh`)

You can also list or create the webhook directly from your terminal using `gh api`:

```bash
# Add webhook using GitHub CLI
gh api repos/:owner/:repo/hooks \
  -f name=web \
  -F "active=true" \
  -F "events[]=push" \
  -F "config[url]=http://<YOUR_JENKINS_SERVER>:8080/github-webhook/" \
  -F "config[content_type]=json"
```

