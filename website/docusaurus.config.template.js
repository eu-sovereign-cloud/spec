// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Sovereign European Cloud API (SECA)',
  tagline: 'An open industry standard, a new Application Programming Interface specification for Cloud Infrastructure Management, paving the way for the EuroStack.',
  favicon: 'img/seca.svg',

  // Set the production url of your site here
  url: 'https://spec.secapi.cloud',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'eu-sovereign-cloud', // Usually your GitHub org/user name.
  projectName: 'spec', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          docItemComponent: "@theme/ApiItem",
       },  
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      image: 'img/seca.svg',
      navbar: {
        logo: {
          alt: 'SECA Logo',
          src: 'img/seca.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'docSidebar',
            position: 'left',
            label: 'Docs',
          },
          {
            type: 'docSidebar',
            sidebarId: 'apiSidebar',
            position: 'left',
            label: 'API',
          },          
          {
            href: 'https://github.com/eu-sovereign-cloud/spec',
            label: 'Repository',
            position: 'right',
          },
          {
            href: 'https://secapi.cloud/',
            label: 'Blog',
            position: 'right',
          },          
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Participate',
            items: [
              {
                label: 'JoinUs',
                href: 'mailto://info@secapi.cloud',
              },
            ],
          },
          {
            title: 'Press enquiries',
            items: [
              {
                label: 'Aruba',
                href: 'mailto:press@staff.aruba.it',
              },
              {
                label: 'IONOS Group',
                href: 'mailto:press@ionos.com',
              },
              {
                label: 'Dynamo',
                href: 'mailto:press@dynamo.cloud',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Blog',
                href: 'https://secapi.cloud/',
              },
              {
                label: 'Repository',
                href: 'https://github.com/eu-sovereign-cloud/spec',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Sovereign Euorpean Cloud API`,
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
    }),

    themes: ["docusaurus-theme-openapi-docs"],
    plugins: [
      [ 
        require.resolve('docusaurus-lunr-search'), 
        {
          languages: ['en'] // language codes
        }
      ],      
      [
        "docusaurus-plugin-openapi-docs",
        {
          id: "openapi",
          docsPluginId: "classic",
          config: __API_CONFIG__,
      } 
      ]
    ]

};


export default config;