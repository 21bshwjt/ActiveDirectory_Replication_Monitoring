# Contributing

Thanks for taking the time to improve **Active Directory Replication Monitoring**!

## Ways to help

- 🐛 **Report bugs:** use the *Bug report* issue template and include your OS and `repadmin` version.
- ✅ **Confirm compatibility:** tell us which Windows Server versions you've run it on.
- 💡 **Suggest features:** check the [Roadmap](README.md#%EF%B8%8F-roadmap) first, then open a *Feature request*.
- 📖 **Improve docs:** typo fixes and clearer examples are always welcome.

## Pull requests

1. Fork the repo and create a branch from `master`.
2. Keep changes focused, one fix or feature per PR.
3. Run PSScriptAnalyzer locally before pushing:
   ```powershell
   Install-Module PSScriptAnalyzer -Scope CurrentUser
   Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error
   ```
4. **Never commit real domain names, server names, email addresses or credentials.** Use `CONTOSO.COM` placeholders.
5. Describe what you tested and in which environment.
