# **Módulo Terraform: cloudops-ref-repo-aws-transversal-terraform**

## Descripción:

Este módulo combina 3 sub módulos (vpc, vpc endpoints y security groups) los cuales permiten:

vpc:

- Crear una VPC con el CIDR block especificado.
- Crear subredes públicas y privadas según la configuración proporcionada.
- Configurar tablas de enrutamiento para cada subred.
- Crear un Internet Gateway (IGW) si se especifica.
- Crear un NAT Gateway si se especifica.
- Configurar rutas personalizadas según sea necesario.
- Configurar el grupo de seguridad predeterminado de la VPC.
- Implementar VPC Flow Logs para monitoreo y auditoría del tráfico de red (característica obligatoria).

vpc endpoints:

- Crear VPC endpoints.

security groups:

- Crear security groups, en este caso para aquellos vpc endpoints que lo requieran.


Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo
El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-transversal-terraform/
└── environments/dev
    ├── terraform.tfvars
├── .gitignore
├── .terraform.lock.hcl
├── CHANGELOG.md
├── data.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── variables.tf
```

- Los archivos principales del módulo (`data.tf`, `main.tf`, `outputs.tf`, `variables.tf`, `providers.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.

## Seguridad & Cumplimiento
 
Consulta a continuación la fecha y los resultados de nuestro escaneo de seguridad y cumplimiento.
 
<!-- BEGIN_BENCHMARK_TABLE -->
| Benchmark | Date | Version | Description | 
| --------- | ---- | ------- | ----------- | 
| ![checkov](https://img.shields.io/badge/checkov-passed-green) | 2023-09-20 | 3.2.232 | Escaneo profundo del plan de Terraform en busca de problemas de seguridad y cumplimiento |
<!-- END_BENCHMARK_TABLE -->

## Provider Configuration

Este módulo requiere la configuración de un provider específico para el proyecto. Debe configurarse de la siguiente manera:

```hcl
sample/vpc/providers.tf
provider "aws" {
  alias = "alias01"
  # ... otras configuraciones del provider
}

sample/vpc/main.tf
module "vpc" {
  source = ""
  providers = {
    aws.project = aws.alias01
  }
  # ... resto de la configuración
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## References (PENDIENTE)

| Module | Use | Resources | Varibales | Outputs |
|------| ----- |------| ----- | ----- |
| vpc | [Ver]() | [Ver]() | [Ver]() | [Ver]() |
| vpc endpoints | [Ver]() | [Ver]() | [Ver]() | [Ver]() |
| security groups | [Ver]() | [Ver]() | [Ver]() | [Ver]() |

