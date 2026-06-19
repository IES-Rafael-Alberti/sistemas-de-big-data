# MLOps / Cloud — Material archivado para Big Data Aplicado

Estos packs se han retirado de la ruta principal de **Sistemas de Big Data (SBD)**
porque su enfoque es MLOps aplicado, cloud y monitorización operativa —
contenido que pertenece a **Big Data Aplicado (BDA)** según el criterio curricular
acordado en la reorganización.

> **SBD** → arquitectura, ingesta, almacenamiento, calidad, procesamiento distribuido,
> selección razonada de herramientas, coste, visualización técnica mínima.
>
> **BDA** → explotación aplicada, BI de negocio, dashboards de solución final,
> monitorización/observabilidad profunda, cloud aplicado E2E.

---

## Contenido

| Pack | Tamaño | Descripción | Recomendación para BDA |
|------|--------|-------------|------------------------|
| `UD_AWS_ML_PIPELINE.zip` | 2 KB | Esqueleto de actividad AWS ML: guías profe/alumno, notebooks, rúbrica, dataset churn.csv | Estructura muy ligera. Si se quiere usar, habría que desarrollarlo más. |
| `lab-mlops-aula.zip` | 1 KB | README + notebook ALUMNO | Muy incompleto. Probablemente descartar o rehacer desde cero. |
| `lab-mlops-monitoring-pro.zip` | 35 KB | Pack completo: preprocesado, train, inferencia, Docker, CI/CD (CodePipeline), ECS, Step Functions, monitorización con detección de deriva, tests A/B | **El más aprovechable.** Tiene código real, Docker, CI/CD, monitorización. Encaja en "observabilidad profunda" de BDA. |

---

## Notas para el profesor de BDA

### lab-mlops-monitoring-pro.zip (el más interesante)

Estructura interna:

```
lab-mlops-monitoring-pro/
├── README.md
├── requirements.txt
├── data/
│   ├── churn_sample.csv
│   └── churn_drift_sample.csv
├── src/
│   ├── preprocess.py
│   ├── train.py
│   └── inference.py
├── pipelines/
│   ├── pipeline.py
│   └── retrain_step.py
├── monitoring/
│   ├── monitoring_guide.md
│   ├── baseline.py
│   └── monitor.py
├── notebooks/
│   ├── PROFESOR.ipynb
│   └── ALUMNO.ipynb
├── infra/
│   └── step_functions.asl.json
├── docker/
│   ├── serve.py
│   └── Dockerfile
├── ci-cd/
│   ├── codepipeline_overview.md
│   └── buildspec.yml
├── ecs/
│   ├── deployment_guide.md
│   └── task_definition.json
└── docs/
    ├── architecture.md
    ├── guia_profesor.md
    ├── guia_alumno.md
    └── ab_testing_sagemaker.md
```

Tecnologías que toca: AWS SageMaker, Step Functions, ECS, CodePipeline, Docker,
monitoring con detección de deriva de datos (data drift). Es un pack sólido para
un módulo aplicado.

### Dependencias

- Los packs asumen **AWS Academy** o cuenta AWS.
- `lab-mlops-monitoring-pro` requiere Docker y Python 3.9+.
- SageMaker y Step Functions tienen coste asociado aunque sea AWS Academy.

---

## Histórico

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Material archivado desde SBD y disponible para BDA. |
