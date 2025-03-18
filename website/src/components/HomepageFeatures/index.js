import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'API First',
    Svg: require('@site/static/img/main/api.svg').default,
    description: (
      <>
        Built on the API-First principle, leveraging OpenAPI to design and document our APIs before implementation. 
        By defining a clear and standardized API contract upfront, we ensure consistency, scalability, and interoperability across web, mobile, and third-party applications
      </>
    ),
  },
  {
    title: 'Declarative Resource Model',
    Svg: require('@site/static/img/main/model.svg').default,
    description: (
      <>
         Follows a Declarative Resource Model, similar to Kubernetes, where users define their desired state, and the platform ensures the system continuously reconciles to match that intent. 
         Instead of managing resources imperatively, users specify configurations in a declarative format, allowing the platform to handle orchestration, scaling, and self-healing automatically
      </>
    ),
  },
  {
    title: 'Fast Adoption',
    Svg: require('@site/static/img/main/shared.svg').default,
    description: (
      <>
        Benefits from fast adoption by leveraging a shared implementation ecosystem to enable standardized resource management across cloud providers. 
        Instead of merely defining interfaces, this approach ensures that both the interface and implementation protocol of shared resources are consistent, reducing integration complexity and accelerating deployment
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
