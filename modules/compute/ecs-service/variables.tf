variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "name" {
  description = "Nome do serviço ECS e da família da task definition."
  type        = string
}

variable "cluster_id" {
  description = "ID do cluster ECS onde o serviço será implantado."
  type        = string
}

# --- Task Definition ---
variable "container_definitions" {
  description = "A definição de contêiner em formato de string JSON. Fornece máxima flexibilidade."
  type        = string
}

variable "enable_execute_command" {
  description = "Habilita conexão no container via aws cli."
  type        = bool
  default     = true
}

variable "force_new_deployment" {
  description = "Force new deployment."
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Atribuir um IP público às tasks do ECS."
  type        = bool
  default     = false
}

variable "task_cpu" {
  description = "A quantidade de CPU (em unidades de CPU) a ser usada pela tarefa."
  type        = number
  default     = null
}

variable "task_memory" {
  description = "A quantidade de memória (em MiB) a ser usada pela tarefa."
  type        = number
  default     = null
}

variable "network_mode" {
  description = "O modo de rede a ser usado para a tarefa (ex: awsvpc, bridge, host)."
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Lista de compatibilidades requeridas pela tarefa (ex: [\"FARGATE\"])."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "task_execution_role_arn" {
  description = "ARN da IAM Role que o agente do contêiner ECS pode assumir para fazer chamadas de API da AWS em seu nome."
  type        = string
}

variable "task_role_arn" {
  description = "ARN da IAM Role que as tarefas podem assumir para interagir com outros serviços da AWS."
  type        = string
  default     = null
}

# --- Service ---
variable "desired_count" {
  description = "O número de instâncias da tarefa que devem ser mantidas em execução."
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "O tipo de lançamento a ser usado para o serviço (Fargate ou EC2)."
  type        = string
  default     = "FARGATE"
}

variable "subnet_ids" {
  description = "As sub-redes a serem associadas ao serviço. Obrigatório para o modo de rede 'awsvpc'."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Os security groups a serem associados ao serviço. Obrigatório para o modo de rede 'awsvpc'."
  type        = list(string)
  default     = []
}

variable "load_balancers" {
  description = "Lista de objetos de load balancer para associar ao serviço."
  type        = any
  default     = []
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar aos recursos."
  type        = map(string)
  default     = {}
}