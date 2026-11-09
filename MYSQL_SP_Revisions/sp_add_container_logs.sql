DELIMITER $$
DROP PROCEDURE IF EXISTS sp_add_container_logs $$
CREATE DEFINER=`vibeadmin`@`%` PROCEDURE `sp_add_container_logs`(
         IN p_integration VARCHAR(50),
      IN p_organisation_id INT,
      IN p_client_id INT,
      IN p_firm_id INT,
      IN p_start_date DATETIME,
      IN p_end_date DATETIME,
      IN p_status VARCHAR(50),
      IN p_log_id VARCHAR(255),
      IN p_remarks TEXT,
      IN p_platform VARCHAR(20),
      IN p_region VARCHAR(50),
      IN p_container_name VARCHAR(100),
      IN p_duration_seconds INT,
      IN p_trigger_type VARCHAR(50),
      IN p_error_details TEXT,
      IN p_vcpu DECIMAL(3,1),
      IN p_memory_gb DECIMAL(4,1),
      IN p_ecs_task_id VARCHAR(100),
      IN p_cloudwatch_url VARCHAR(500),
      -- New enhanced resource tracking parameters
      IN p_task_definition VARCHAR(100),
      IN p_vcpu_allocated DECIMAL(3,1),
      IN p_memory_gb_allocated DECIMAL(4,1),
      IN p_cpu_peak_pct DECIMAL(5,2),
      IN p_cpu_avg_pct DECIMAL(5,2),
      IN p_memory_peak_gb DECIMAL(5,3),
      IN p_memory_avg_gb DECIMAL(5,3),
      IN p_recommended_size VARCHAR(20),
      IN p_cost_usd DECIMAL(8,4)
  )
BEGIN
      -- Check if log_id already exists
      IF EXISTS (SELECT 1 FROM vibedb_cms.container_logs WHERE log_id = p_log_id) THEN
          -- Update existing record
          UPDATE vibedb_cms.container_logs
          SET
              end_date = p_end_date,
              status = p_status,
              remarks = p_remarks,
              duration_seconds = p_duration_seconds,
              error_details = p_error_details,
              vcpu = COALESCE(p_vcpu, vcpu),
              memory_gb = COALESCE(p_memory_gb, memory_gb),
              ecs_task_id = COALESCE(p_ecs_task_id, ecs_task_id),
              cloudwatch_url = COALESCE(p_cloudwatch_url, cloudwatch_url),
              task_definition = COALESCE(p_task_definition, task_definition),
              vcpu_allocated = COALESCE(p_vcpu_allocated, vcpu_allocated),
              memory_gb_allocated = COALESCE(p_memory_gb_allocated, memory_gb_allocated),
              cpu_peak_pct = COALESCE(p_cpu_peak_pct, cpu_peak_pct),
              cpu_avg_pct = COALESCE(p_cpu_avg_pct, cpu_avg_pct),
              memory_peak_gb = COALESCE(p_memory_peak_gb, memory_peak_gb),
              memory_avg_gb = COALESCE(p_memory_avg_gb, memory_avg_gb),
              recommended_size = COALESCE(p_recommended_size, recommended_size),
              cost_usd = COALESCE(p_cost_usd, cost_usd)
          WHERE log_id = p_log_id;
      ELSE
          -- Insert new record
          INSERT INTO vibedb_cms.container_logs (
              integration, organisation_id, client_id, firm_id,
              start_date, end_date, status, log_id, remarks,
              platform, region, container_name, duration_seconds,
              trigger_type, error_details, vcpu, memory_gb,
              ecs_task_id, cloudwatch_url,
              task_definition, vcpu_allocated, memory_gb_allocated,
              cpu_peak_pct, cpu_avg_pct, memory_peak_gb, memory_avg_gb,
              recommended_size, cost_usd
          ) VALUES (
              p_integration, p_organisation_id, p_client_id, p_firm_id,
              p_start_date, p_end_date, p_status, p_log_id, p_remarks,
              p_platform, p_region, p_container_name, p_duration_seconds,
              p_trigger_type, p_error_details, p_vcpu, p_memory_gb,
              p_ecs_task_id, p_cloudwatch_url,
              p_task_definition, p_vcpu_allocated, p_memory_gb_allocated,
              p_cpu_peak_pct, p_cpu_avg_pct, p_memory_peak_gb, p_memory_avg_gb,
              p_recommended_size, p_cost_usd
          );
      END IF;
  END$$

DELIMITER ;
