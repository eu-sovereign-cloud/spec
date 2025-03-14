import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebar: SidebarsConfig = {
  apisidebar: [
    {
      type: "doc",
      id: "documents/activitylog/sovereign-european-cloud-api-activity-log",
    },
    {
      type: "category",
      label: "Observability",
      link: {
        type: "doc",
        id: "documents/activitylog/observability",
      },
      items: [
        {
          type: "doc",
          id: "documents/activitylog/list-audit-logs",
          label: "List all Audit Logs",
          className: "api-method get",
        },
      ],
    },
  ],
};

export default sidebar.apisidebar;
