module.exports = {
  defaultBrowser: "Firefox",
  options: {
    hideIcon: false
  },
  handlers: [
    {
      match: ({ opener }) =>
        opener.bundleId === "com.tinyspeck.slackmacgap",
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "work", `${urlString}`],
      })
    },
    {
      match: ({ opener }) =>
        opener.path && opener.path.startsWith("/Applications/Slack.app"),
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "work", `${urlString}`],
      })
    },
    {
      match: ({ opener }) =>
        opener.path && opener.path.startsWith("/Applications/Microsoft Outlook.app"),
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "work", `${urlString}`],
      })
    },
    {
      match: ({ opener }) =>
        opener.path && opener.path.startsWith("/Applications/Microsoft Teams classic.app"),
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "work", `${urlString}`],
      })
    },
    {
      match: ["http://google.*"],
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "home", `${urlString}`],
      })
    },
    {
      match: ({ opener }) =>
        opener.path && opener.path.startsWith("/Applications/Telegram.app"),
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "home", `${urlString}`],
      })
    },
    // {
    //   match: finicky.matchHostnames(["gitlab.com", "fhl.world", "atlassian.net", "sharepoint.com", "amazon.com", "awsapps.com"]),
    //   // Opens the first running browsers in the list. If none are running, the first one will be started.
    //   browser: ["Google Chrome", "Safari", "Firefox"]
    // },
    {
      // match: finicky.matchHostnames(["gitlab.com", "fhl.world", "atlassian.net", "atlassian.com", "sharepoint.com", "amazon.com", "awsapps.com"]),
      match: [
        /.*gitlab.com.*/,
        /.*fhl.world.*/,
        /.*atlassian\.(com|net).*/,
        /.*sharepoint.com.*/,
        /.*amazon.com.*/,
        /.*awsapps.com.*/,
        /.*amazonaws.com.*/,
        /.*databricks.com.*/
      ],
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "work", `${urlString}`],
      })
    },
    {
      match: ["http://example.com"],
      // Don't open any browser for this url, effectively blocking it
      browser: null
    },
    {
      // Open links in Safari when the option key is pressed
      // Valid keys are: shift, option, command, control, capsLock, and function.
      // Please note that control usually opens a tooltip menu instead of visiting a link
      match: () => finicky.getKeys().option,
      browser: ({ urlString }) => ({
        name: "Firefox",
        args: ["-P", "home", `${urlString}`],
      })
    }
  ]
};
