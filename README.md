# ProjectIcchi

ProjectIcchi is a JSP-based library management app branded as Garden of Knowledge.

## Run locally in VS Code

1. Open the workspace in VS Code.
2. Run the task named `Run ProjectIcchi` from Terminal > Run Task.
3. Open `http://localhost:8080/ProjectIcchi/login.jsp` in your browser.
4. Use one of the demo logins:
   - `admin / admin123`
   - `user / user123`

The project uses an embedded H2 database. The first run task will download Tomcat 10.1.55 into `tools/tomcat/apache-tomcat-10.1.55` if it is not already present.

## Notes

- The application is a NetBeans web project, so the original build files are still present.
- Generated output folders such as `build/` and `dist/` should not be committed.